/*
 * AIDAtanaly.com — Transition Scanner v1
 * Governed by: SCANNER_MODEL.md v1.0, INTERFACE_GOVERNANCE.md v1.0,
 * IMPLEMENTATION_PLAN.md Sprint 6.
 *
 * Reads scoring rules, questions, thresholds, and failure mode mappings from
 * /data/*.json only. Evidence Confidence is never a score component.
 */

(function () {
  "use strict";

  var DATA_URLS = {
    scanner: "/data/scanner-model.json",
    ati: "/data/ati-standard.json",
    tfo: "/data/tfo-failure-modes.json",
    layers: "/data/intervention-layers.json",
  };

  var VECTOR_EVIDENCE = {
    "ati.vector.t1": ["ev.analytics"],
    "ati.vector.t2": ["ev.analytics", "ev.crm_or_leads"],
    "ati.vector.t3": ["ev.conversion_tracking"],
    "ati.vector.t4": ["ev.retention"],
  };

  var state = {
    scanner: null,
    ati: null,
    tfo: null,
    layers: null,
    tfoById: {},
    layerById: {},
    vectorMeta: {},
    answers: {},
    currentStep: 0,
    steps: [],
  };

  function $(sel, root) {
    return (root || document).querySelector(sel);
  }

  function escapeHtml(str) {
    if (str == null) return "";
    return String(str)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function fetchJson(url) {
    return fetch(url).then(function (res) {
      if (!res.ok) throw new Error("Failed to load " + url);
      return res.json();
    });
  }

  function indexRegistry(items, key) {
    var map = {};
    (items || []).forEach(function (item) {
      map[item[key || "id"]] = item;
    });
    return map;
  }

  function average(nums) {
    if (!nums.length) return 0;
    return nums.reduce(function (a, b) {
      return a + b;
    }, 0) / nums.length;
  }

  function scoreFromAnswer(value, answerScale) {
    var entry = answerScale.find(function (s) {
      return s.value === value;
    });
    return entry ? entry.score_equivalent : 0;
  }

  function diagnosticClassForScore(score, thresholds) {
    var match = thresholds.find(function (t) {
      return score >= t.min_score && score <= t.max_score;
    });
    return match || thresholds[thresholds.length - 1];
  }

  function classModifier(className) {
    var slug = (className || "")
      .replace(/^Transition\s+/i, "")
      .toLowerCase()
      .replace(/\s+/g, "-");
    return slug || "critical";
  }

  function buildVectorMeta(atiVectors) {
    var meta = {};
    (atiVectors.vectors || []).forEach(function (v) {
      meta[v.vector_id] = v;
    });
    return meta;
  }

  function buildTfoRegistry(tfo) {
    var byId = {};
    (tfo.failure_modes || []).forEach(function (fm) {
      byId[fm.id] = fm;
    });
    (tfo.diagnostic_constraints || []).forEach(function (cx) {
      byId[cx.id] = cx;
    });
    return byId;
  }

  function getEvidenceAnswer(id) {
    var val = state.answers[id];
    return typeof val === "number" ? val : 0;
  }

  function hasRequiredEvidence(vectorId) {
    var keys = VECTOR_EVIDENCE[vectorId] || [];
    return keys.some(function (key) {
      return getEvidenceAnswer(key) >= 2;
    });
  }

  function computeBaselineEvidenceLevel() {
    var keys = [
      "ev.analytics",
      "ev.conversion_tracking",
      "ev.crm_or_leads",
      "ev.retention",
      "ev.source_linkage",
      "ev.time_window",
    ];
    var scores = keys.map(getEvidenceAnswer);
    var avg = average(scores);
    var multi = getEvidenceAnswer("ev.source_linkage") >= 3 && getEvidenceAnswer("ev.time_window") >= 3;

    if (avg === 0) return { code: "E0", name: "Absent Evidence" };
    if (avg <= 1) return { code: "E1", name: "Self-Reported Evidence" };
    if (avg <= 2 && !multi) return { code: "E2", name: "Observable Evidence" };
    if (multi && avg < 3.5) return { code: "E3", name: "Multi-Source Evidence" };
    if (avg >= 3.5 && getEvidenceAnswer("ev.time_window") >= 3) {
      return { code: "E4", name: "Validated Evidence" };
    }
    return { code: "E2", name: "Observable Evidence" };
  }

  function assignVectorEvidence(vectorModel, vectorAnswers) {
    var values = vectorModel.questions.map(function (q) {
      return state.answers[q.id];
    });
    var allUntracked = values.every(function (v) {
      return v === 0;
    });

    if (allUntracked || !hasRequiredEvidence(vectorModel.vector_id)) {
      return { code: "E0", name: "Absent Evidence", unscorable: true };
    }

    var baseline = computeBaselineEvidenceLevel();
    if (baseline.code === "E0") {
      return { code: "E0", name: "Absent Evidence", unscorable: true };
    }

    var avgVector =
      average(
        values.map(function (v) {
          return scoreFromAnswer(v, state.scanner.answer_scale);
        })
      ) / 100;

    if (avgVector <= 0.25 && getEvidenceAnswer("ev.analytics") <= 1) {
      return { code: "E1", name: "Self-Reported Evidence", unscorable: false };
    }

    return { code: baseline.code, name: baseline.name, unscorable: false };
  }

  function computeVectorScore(vectorModel) {
    var dimScores = {};
    var dimensions = state.scanner.dimensions;
    var answerScale = state.scanner.answer_scale;

    vectorModel.questions.forEach(function (q) {
      var val = state.answers[q.id];
      if (typeof val !== "number") return;
      if (!dimScores[q.dimension]) dimScores[q.dimension] = [];
      dimScores[q.dimension].push(scoreFromAnswer(val, answerScale));
    });

    var total = 0;
    dimensions.forEach(function (d) {
      var scores = dimScores[d.id] || [];
      var dimAvg = scores.length ? average(scores) : 0;
      total += dimAvg * d.weight;
    });

    return Math.round(total);
  }

  function patternStrength(fmId, vectorModel) {
    var relevant = vectorModel.questions.filter(function (q) {
      return q.failure_mode_signals && q.failure_mode_signals.indexOf(fmId) !== -1;
    });
    if (!relevant.length) return 0;

    var weakness = relevant.map(function (q) {
      var val = state.answers[q.id];
      if (typeof val !== "number") return 100;
      return 100 - scoreFromAnswer(val, state.scanner.answer_scale);
    });

    return Math.round(average(weakness));
  }

  function assignFailureModes(vectorModel, vectorScore, evidence) {
    var levels = state.scanner.failure_mode_assignment.pattern_strength_levels;
    var triggers = vectorModel.failure_mode_triggers || [];
    var ranked = triggers
      .map(function (tr) {
        return {
          id: tr.id,
          strength: patternStrength(tr.id, vectorModel),
        };
      })
      .filter(function (row) {
        return state.tfoById[row.id];
      })
      .sort(function (a, b) {
        return b.strength - a.strength;
      });

    if (evidence.code === "E0") {
      var gap = state.tfoById["tfo.constraint.measurement_gap"];
      if (gap) {
        return {
          primary: gap,
          secondary: ranked.slice(0, 2).map(function (r) {
            return state.tfoById[r.id];
          }),
          measurementGap: true,
        };
      }
    }

    function levelFor(strength) {
      return levels.find(function (l) {
        return strength >= l.min && strength <= l.max;
      });
    }

    var likely = ranked.filter(function (r) {
      var lvl = levelFor(r.strength);
      return lvl && lvl.assignment !== "not_assigned" && lvl.assignment !== "weak_signal";
    });

    if (!likely.length && vectorScore < 70) {
      likely = ranked.filter(function (r) {
        return levelFor(r.strength) && levelFor(r.strength).assignment !== "not_assigned";
      });
    }

    return {
      primary: likely[0] ? state.tfoById[likely[0].id] : null,
      secondary: likely.slice(1, 3).map(function (r) {
        return state.tfoById[r.id];
      }),
      measurementGap: false,
    };
  }

  function collectInterventionLayers(failureModes) {
    var ids = [];
    var names = [];
    failureModes.forEach(function (fm) {
      if (!fm || !fm.intervention_layers) return;
      fm.intervention_layers.forEach(function (layerId) {
        if (ids.indexOf(layerId) === -1) {
          ids.push(layerId);
          var layer = state.layerById[layerId];
          if (layer) names.push(layer);
        }
      });
    });
    return names;
  }

  function computeResults() {
    var thresholds = state.scanner.diagnostic_thresholds;
    var vectorModels = state.scanner.vector_question_models;
    var vectorResults = vectorModels.map(function (vm) {
      var meta = state.vectorMeta[vm.vector_id] || {};
      var evidence = assignVectorEvidence(vm, state.answers);
      var score = evidence.unscorable ? null : computeVectorScore(vm);
      var diag =
        score == null
          ? null
          : diagnosticClassForScore(score, thresholds);
      var failureModes = assignFailureModes(vm, score || 0, evidence);

      return {
        vectorId: vm.vector_id,
        code: meta.code || vm.vector_id,
        transition: vm.transition,
        transitionName: meta.transition_name || "",
        route: meta.canonical_route || "",
        coreQuestion: vm.core_question,
        score: score,
        evidence: evidence,
        diagnostic: diag,
        failureModes: failureModes,
      };
    });

    var scorable = vectorResults.filter(function (vr) {
      return !vr.evidence.unscorable && vr.score != null;
    });
    var unscorable = vectorResults.filter(function (vr) {
      return vr.evidence.unscorable;
    });

    var composite = null;
    var partial = unscorable.length > 0;
    if (!partial && scorable.length === 4) {
      var compositeScore = Math.round(
        average(
          scorable.map(function (vr) {
            return vr.score;
          })
        )
      );
      composite = {
        score: compositeScore,
        diagnostic: diagnosticClassForScore(compositeScore, thresholds),
      };
    }

    var rankedScorable = scorable.slice().sort(function (a, b) {
      return a.score - b.score;
    });
    var weakest = rankedScorable[0] || null;
    var strongest = rankedScorable.length
      ? rankedScorable[rankedScorable.length - 1]
      : null;

    var allFailureModes = [];
    vectorResults.forEach(function (vr) {
      if (vr.failureModes.primary) allFailureModes.push(vr.failureModes.primary);
      (vr.failureModes.secondary || []).forEach(function (fm) {
        if (fm) allFailureModes.push(fm);
      });
    });

    var uniqueFm = [];
    allFailureModes.forEach(function (fm) {
      if (!fm) return;
      if (
        !uniqueFm.some(function (x) {
          return x.id === fm.id;
        })
      ) {
        uniqueFm.push(fm);
      }
    });

    return {
      vectorResults: vectorResults,
      composite: composite,
      partial: partial,
      scorable: scorable,
      unscorable: unscorable,
      weakest: weakest,
      strongest: strongest,
      failureModes: uniqueFm,
      interventions: collectInterventionLayers(uniqueFm),
      baselineEvidence: computeBaselineEvidenceLevel(),
    };
  }

  function evidenceBadge(code, name, e0) {
    var cls = e0 ? " badge-evidence--e0" : "";
    return (
      '<span class="badge-evidence' +
      cls +
      '"><span class="badge-evidence__code">' +
      escapeHtml(code) +
      "</span> " +
      escapeHtml(name) +
      "</span>"
    );
  }

  function diagnosticBadge(diag) {
    if (!diag) return "";
    var mod = classModifier(diag.name);
    return (
      '<span class="badge-diagnostic badge-diagnostic--' +
      mod +
      '">' +
      escapeHtml(diag.name) +
      ' <span class="badge-diagnostic__range">' +
      diag.min_score +
      "&ndash;" +
      diag.max_score +
      "</span></span>"
    );
  }

  function renderVectorResult(vr) {
    var html = '<article class="vector-card">';
    html +=
      '<p class="vector-card__direction"><span class="vector-card__state">' +
      escapeHtml(vr.transition.split("→")[0].trim()) +
      '</span><span class="vector-card__arrow" aria-hidden="true">&#8594;</span><span class="vector-card__state">' +
      escapeHtml(vr.transition.split("→")[1].trim()) +
      "</span></p>";
    html +=
      "<h3 class=\"vector-card__title\">" +
      escapeHtml(vr.code) +
      (vr.transitionName ? " — " + escapeHtml(vr.transitionName) : "") +
      "</h3>";
    html +=
      '<p class="vector-card__question">' + escapeHtml(vr.coreQuestion) + "</p>";
    html += '<p class="vector-card__meta">';
    if (vr.route) {
      html +=
        '<a href="' +
        escapeHtml(vr.route) +
        '"><span class="stable-id-chip">' +
        escapeHtml(vr.vectorId) +
        "</span></a> ";
    }
    if (vr.evidence.unscorable) {
      html +=
        '<span class="evidence-unscorable__label">' +
        escapeHtml(vr.code) +
        ": Unscorable</span> ";
      html += evidenceBadge("E0", "Absent Evidence", true);
      html +=
        '</p><div class="evidence-unscorable"><p class="evidence-unscorable__note">No numeric score is issued for this vector. Required evidence is missing or not tracked. See <a href="/failure-modes/measurement-gap/">Measurement Gap</a>.</p></div>';
    } else {
      html += diagnosticBadge(vr.diagnostic);
      html += " ";
      html += evidenceBadge(vr.evidence.code, vr.evidence.name, vr.evidence.code === "E0");
      html += '</p><div class="score-panel score-panel--' + classModifier(vr.diagnostic.name) + '">';
      html += '<span class="score-panel__value">' + vr.score + "</span>";
      html +=
        '<span class="score-panel__bar"><span class="score-panel__bar-fill" style="width:' +
        vr.score +
        '%"></span></span>';
      html += "</div>";
    }

    var fm = vr.failureModes;
    if (fm.primary || (fm.secondary && fm.secondary.length)) {
      html += "<h4>Likely failure modes</h4><ul>";
      if (fm.primary) {
        html +=
          "<li><a href=\"" +
          escapeHtml(fm.primary.canonical_route) +
          '">' +
          escapeHtml(fm.primary.name) +
          '</a> <span class="stable-id-chip">' +
          escapeHtml(fm.primary.id) +
          "</span></li>";
      }
      (fm.secondary || []).forEach(function (s) {
        if (!s) return;
        html +=
          "<li><a href=\"" +
          escapeHtml(s.canonical_route) +
          '">' +
          escapeHtml(s.name) +
          '</a> <span class="stable-id-chip">' +
          escapeHtml(s.id) +
          "</span></li>";
      });
      html += "</ul>";
    }
    html += "</article>";
    return html;
  }

  function healthModifierForVector(vr) {
    if (vr.evidence.unscorable) return "unscorable";
    if (!vr.diagnostic) return "functional";
    return classModifier(vr.diagnostic.name);
  }

  function healthLabelForVector(vr) {
    if (vr.evidence.unscorable) return vr.code + " Unscorable";
    var shortName = (vr.diagnostic.name || "").replace(/^Transition\s+/i, "");
    return vr.code + " " + shortName;
  }

  function primaryFailureMode(result) {
    if (result.weakest && result.weakest.failureModes && result.weakest.failureModes.primary) {
      return result.weakest.failureModes.primary;
    }
    return result.failureModes.length ? result.failureModes[0] : null;
  }

  function renderTransitionHealthMap(result) {
    var html =
      '<div class="scanner-result-map" aria-label="Transition Health Map">';
    html += "<h3>Transition Health Map</h3>";
    html +=
      '<ol class="scanner-result-map__axis" aria-label="Movement quality across T1 through T4">';

    var segments = [
      { type: "state", label: "Attention" },
      { type: "vector", vr: result.vectorResults[0] },
      { type: "state", label: "Interest" },
      { type: "vector", vr: result.vectorResults[1] },
      { type: "state", label: "Desire" },
      { type: "vector", vr: result.vectorResults[2] },
      { type: "state", label: "Action" },
      { type: "vector", vr: result.vectorResults[3] },
      { type: "state", label: "Loyalty" },
    ];

    var summaryParts = [];

    segments.forEach(function (seg) {
      if (seg.type === "state") {
        html +=
          '<li class="scanner-result-map__state">' +
          escapeHtml(seg.label) +
          "</li>";
        return;
      }

      var vr = seg.vr;
      if (!vr) return;
      var mod = healthModifierForVector(vr);
      var classes =
        "scanner-result-map__vector scanner-result-map__vector--" + mod;
      if (result.weakest && result.weakest.code === vr.code) {
        classes += " scanner-result-map__vector--focus";
      }
      html += '<li class="' + classes + '">';
      html +=
        '<span class="scanner-result-map__label">' +
        escapeHtml(healthLabelForVector(vr)) +
        "</span></li>";
      summaryParts.push(healthLabelForVector(vr));
    });

    html += "</ol>";
    html +=
      '<p class="scanner-result-map__summary utility-visually-hidden">Transition health map: ' +
      escapeHtml(summaryParts.join("; ")) +
      ".</p>";
    html += "</div>";
    return html;
  }

  function renderMovementFocus(title, vr, kind) {
    if (!vr) return "";
    var html = "<h3>" + escapeHtml(title) + "</h3>";
    html += '<div class="scanner-result-map__focus scanner-result-map__focus--' + kind + '">';
    html +=
      "<p><strong>" +
      escapeHtml(vr.code) +
      "</strong> — " +
      escapeHtml(vr.transition);
    if (vr.evidence.unscorable) {
      html += " — Unscorable / E0 Absent Evidence";
    } else {
      html +=
        " — " +
        escapeHtml(vr.diagnostic.name) +
        " (Score " +
        vr.score +
        ")";
    }
    if (vr.route) {
      html +=
        ' (<a href="' + escapeHtml(vr.route) + '">vector profile</a>)';
    }
    html += "</p>";
    if (
      vr.failureModes &&
      vr.failureModes.primary &&
      kind === "weakest"
    ) {
      html +=
        '<p>Likely failure: <a href="' +
        escapeHtml(vr.failureModes.primary.canonical_route) +
        '">' +
        escapeHtml(vr.failureModes.primary.name) +
        '</a> <span class="stable-id-chip">' +
        escapeHtml(vr.failureModes.primary.id) +
        "</span></p>";
    }
    html += "</div>";
    return html;
  }

  function renderResults(result) {
    var routes = state.scanner.canonical_routes;
    var html = "";

    html += "<h3>Composite Status</h3>";
    if (result.partial) {
      var scorableCodes = result.scorable
        .map(function (vr) {
          return vr.code;
        })
        .join(", ");
      var unscorableCodes = result.unscorable
        .map(function (vr) {
          return vr.code;
        })
        .join(", ");
      html += '<div class="evidence-unscorable scanner-results__partial">';
      html += "<p><strong>ATI Profile: Partial</strong></p>";
      html += "<p>Scorable vectors: " + escapeHtml(scorableCodes || "none") + "</p>";
      html +=
        "<p>Unscorable vectors: " +
        escapeHtml(unscorableCodes || "none") +
        " / E0 Absent Evidence</p>";
      html +=
        '<p class="utility-muted">' +
        escapeHtml(state.scanner.partial_profile_rule.statement) +
        "</p>";
      html += "</div>";
    } else if (result.composite) {
      html +=
        '<div class="score-panel score-panel--' +
        classModifier(result.composite.diagnostic.name) +
        '">';
      html +=
        '<span class="score-panel__value">' + result.composite.score + "</span>";
      html +=
        '<span class="score-panel__bar"><span class="score-panel__bar-fill" style="width:' +
        result.composite.score +
        '%"></span></span>';
      html += diagnosticBadge(result.composite.diagnostic);
      html += evidenceBadge(result.baselineEvidence.code, result.baselineEvidence.name, false);
      html += "</div>";
      html +=
        "<p>Composite ATI: <strong>" +
        result.composite.score +
        "</strong> — " +
        escapeHtml(result.composite.diagnostic.name) +
        ' (<a href="' +
        routes.ati_standard +
        '">ATI Standard</a>)</p>';
    }

    html += renderTransitionHealthMap(result);

    html += renderMovementFocus("Weakest Movement", result.weakest, "weakest");
    html += renderMovementFocus("Strongest Movement", result.strongest, "strongest");

    html += "<h3>Primary Failure Mode</h3>";
    var primaryFm = primaryFailureMode(result);
    if (primaryFm) {
      html +=
        "<p><a href=\"" +
        escapeHtml(primaryFm.canonical_route) +
        '"><strong>' +
        escapeHtml(primaryFm.name) +
        '</strong></a> <span class="stable-id-chip">' +
        escapeHtml(primaryFm.id) +
        "</span></p>";
      if (result.failureModes.length > 1) {
        html += "<p>Related patterns:</p><ul>";
        result.failureModes.slice(1, 4).forEach(function (fm) {
          html +=
            "<li><a href=\"" +
            escapeHtml(fm.canonical_route) +
            '">' +
            escapeHtml(fm.name) +
            '</a> <span class="stable-id-chip">' +
            escapeHtml(fm.id) +
            "</span></li>";
        });
        html += "</ul>";
      }
    } else {
      html += "<p>No dominant failure mode pattern detected at the current signal strength.</p>";
    }

    html += "<h3>Recommended Intervention Layers</h3>";
    if (result.interventions.length) {
      html += "<p>";
      result.interventions.forEach(function (layer) {
        html +=
          '<span class="intervention-tag">' + escapeHtml(layer.name) + "</span> ";
      });
      html += "</p>";
      html +=
        '<p>See <a href="' +
        routes.intervention_layers +
        '">Intervention Layers</a> for the governed registry.</p>";
    } else {
      html += "<p>No intervention layer recommendation at this signal level.</p>";
    }

    html += "<h3>Evidence Confidence Summary</h3>";
    html += "<p>" + evidenceBadge(result.baselineEvidence.code, result.baselineEvidence.name, result.baselineEvidence.code === "E0") + "</p>";
    html +=
      '<p class="utility-muted">Evidence Confidence qualifies how strongly this result should be interpreted. It is not part of the ATI score. See <a href="' +
      routes.evidence_confidence +
      '">Evidence Confidence</a>.</p>';

    html += "<h3>Reference Links</h3>";
    html += '<nav class="reference-links" aria-label="Scanner reference links"><ul class="reference-links__list">';
    html +=
      '<li><a href="' +
      routes.ati_standard +
      '">AIDA Transition Index</a></li>';
    html +=
      '<li><a href="' +
      routes.tfo_overview +
      '">Transition Failure Ontology</a></li>';
    html +=
      '<li><a href="' +
      routes.evidence_confidence +
      '">Evidence Confidence</a></li>';
    html +=
      '<li><a href="' +
      routes.intervention_layers +
      '">Intervention Layers</a></li>';
    html +=
      '<li><a href="' +
      routes.measurement_gap +
      '">Measurement Gap</a></li>';
    html +=
      '<li><a href="' +
      routes.methodology +
      '">Methodology</a></li>';
    html += "</ul></nav>";

    return html;
  }

  function updateAxis(result) {
    var axis = $("#scanner-axis");
    if (!axis) return;
    var nodes = axis.querySelectorAll(".transition-axis__vector");
    result.vectorResults.forEach(function (vr, idx) {
      var node = nodes[idx];
      if (!node) return;
      node.className = "transition-axis__vector transition-axis__vector--reference";
      if (vr.evidence.unscorable) {
        node.classList.remove("transition-axis__vector--reference");
        node.classList.add("transition-axis__vector--unscorable");
      } else if (vr.diagnostic) {
        node.classList.remove("transition-axis__vector--reference");
        node.classList.add(
          "transition-axis__vector--" + classModifier(vr.diagnostic.name)
        );
      }
    });
  }

  function buildSteps() {
    var steps = [];
    steps.push({
      id: "funnel_context",
      title: "Step 1: Funnel Context",
      questions: state.scanner.context_questions,
      kind: "context",
    });
    steps.push({
      id: "measurement_availability",
      title: "Step 2: Measurement Availability",
      questions: state.scanner.evidence_questions,
      kind: "evidence",
    });
    state.scanner.vector_question_models.forEach(function (vm, idx) {
      var meta = state.vectorMeta[vm.vector_id] || {};
      steps.push({
        id: vm.vector_id,
        title:
          "Step " +
          (idx + 3) +
          ": " +
          (meta.code || "T") +
          " — " +
          vm.transition,
        questions: vm.questions,
        kind: "vector",
        vectorModel: vm,
      });
    });
    state.steps = steps;
  }

  function renderOptionLabels(answerScale) {
    return answerScale
      .map(function (opt) {
        return (
          '<label class="scanner-option"><input type="radio" required value="' +
          opt.value +
          '"> ' +
          escapeHtml(opt.value + " — " + opt.label) +
          "</label>"
        );
      })
      .join("");
  }

  function renderContextControl(q) {
    if (q.id === "ctx.business_model" && q.allowed_values) {
      return (
        '<label class="scanner-panel__question" for="' +
        q.id +
        '">' +
        escapeHtml(q.question) +
        '</label><select class="scanner-select" id="' +
        q.id +
        '" name="' +
        q.id +
        '" required><option value="">Select…</option>' +
        q.allowed_values
          .map(function (v) {
            return (
              '<option value="' + escapeHtml(v) + '">' + escapeHtml(v.replace(/_/g, " ")) + "</option>"
            );
          })
          .join("") +
        "</select>"
      );
    }
    if (q.id === "ctx.sales_cycle") {
      return (
        '<fieldset><legend class="scanner-panel__question">' +
        escapeHtml(q.question) +
        '</legend><label class="scanner-option"><input type="radio" name="' +
        q.id +
        '" value="fast" required> Fast cycle</label><label class="scanner-option"><input type="radio" name="' +
        q.id +
        '" value="medium"> Medium cycle</label><label class="scanner-option"><input type="radio" name="' +
        q.id +
        '" value="long"> Long cycle</label></fieldset>'
      );
    }
    return (
      '<label class="scanner-panel__question" for="' +
      q.id +
      '">' +
      escapeHtml(q.question) +
      '</label><input class="scanner-text" type="text" id="' +
      q.id +
      '" name="' +
      q.id +
      '" required autocomplete="off">'
    );
  }

  function renderStepPanel(step, index) {
    var panel = document.createElement("section");
    panel.className = "scanner-step layout-section";
    panel.dataset.stepIndex = String(index);
    panel.hidden = index !== 0;
    panel.innerHTML =
      "<h2>" +
      escapeHtml(step.title) +
      '</h2><form class="scanner-panel" data-step-id="' +
      escapeHtml(step.id) +
      '">';

    if (step.kind === "context") {
      step.questions.forEach(function (q) {
        panel.querySelector(".scanner-panel").insertAdjacentHTML(
          "beforeend",
          renderContextControl(q)
        );
      });
    } else {
      step.questions.forEach(function (q, qIdx) {
        var block =
          '<fieldset data-question-id="' +
          escapeHtml(q.id) +
          '"><legend><p class="scanner-panel__progress">' +
          escapeHtml(step.title) +
          " · Question " +
          (qIdx + 1) +
          " of " +
          step.questions.length +
          '</p><p class="scanner-panel__question">' +
          escapeHtml(q.question) +
          "</p></legend>" +
          renderOptionLabels(state.scanner.answer_scale) +
          "</fieldset>";
        panel.querySelector(".scanner-panel").insertAdjacentHTML("beforeend", block);
      });
    }

    return panel;
  }

  function readStepAnswers(stepEl, step) {
    if (step.kind === "context") {
      step.questions.forEach(function (q) {
        if (q.id === "ctx.sales_cycle") {
          var picked = stepEl.querySelector('input[name="' + q.id + '"]:checked');
          state.answers[q.id] = picked ? picked.value : "";
          return;
        }
        var field = stepEl.querySelector('[name="' + q.id + '"]');
        state.answers[q.id] = field ? field.value : "";
      });
      return true;
    }

    var ok = true;
    step.questions.forEach(function (q) {
      var fieldset = stepEl.querySelector('[data-question-id="' + q.id + '"]');
      var picked = fieldset ? fieldset.querySelector("input:checked") : null;
      if (!picked) {
        ok = false;
        return;
      }
      state.answers[q.id] = parseInt(picked.value, 10);
    });
    return ok;
  }

  function showStep(index) {
    state.currentStep = index;
    document.querySelectorAll(".scanner-step").forEach(function (el) {
      el.hidden = parseInt(el.dataset.stepIndex, 10) !== index;
    });
    var prev = $("#scanner-prev");
    var next = $("#scanner-next");
    var submit = $("#scanner-submit");
    if (prev) prev.disabled = index === 0;
    if (next) next.hidden = index === state.steps.length - 1;
    if (submit) submit.hidden = index !== state.steps.length - 1;
    var progress = $("#scanner-progress");
    if (progress) {
      progress.textContent =
        "Step " + (index + 1) + " of " + state.steps.length;
    }
  }

  function validateWeights() {
    var scannerDims = state.scanner.dimensions;
    var atiDims = state.ati.dimensions;
    scannerDims.forEach(function (d) {
      var atiD = atiDims.find(function (x) {
        return x.id === d.id;
      });
      if (atiD && atiD.weight !== d.weight) {
        console.warn("Dimension weight mismatch for " + d.id);
      }
    });
  }

  function initWizard() {
    buildSteps();
    validateWeights();
    var host = $("#scanner-steps");
    if (!host) return;

    state.steps.forEach(function (step, idx) {
      host.appendChild(renderStepPanel(step, idx));
    });

    var prev = $("#scanner-prev");
    var next = $("#scanner-next");
    var submit = $("#scanner-submit");

    if (next) {
      next.addEventListener("click", function () {
        var step = state.steps[state.currentStep];
        var stepEl = host.querySelector('[data-step-index="' + state.currentStep + '"]');
        if (!readStepAnswers(stepEl, step)) {
          alert("Please answer every question on this step before continuing.");
          return;
        }
        showStep(state.currentStep + 1);
        stepEl.querySelector(".scanner-panel").scrollIntoView({ behavior: "smooth", block: "start" });
      });
    }

    if (prev) {
      prev.addEventListener("click", function () {
        showStep(Math.max(0, state.currentStep - 1));
      });
    }

    if (submit) {
      submit.addEventListener("click", function () {
        var step = state.steps[state.currentStep];
        var stepEl = host.querySelector('[data-step-index="' + state.currentStep + '"]');
        if (!readStepAnswers(stepEl, step)) {
          alert("Please answer every question on this step before generating the diagnosis.");
          return;
        }
        var result = computeResults();
        var out = $("#scanner-results-body");
        if (out) out.innerHTML = renderResults(result);
        updateAxis(result);
        var resultsSection = $("#scanner-results");
        if (resultsSection) {
          resultsSection.hidden = false;
          resultsSection.scrollIntoView({ behavior: "smooth", block: "start" });
        }
      });
    }

    showStep(0);
  }

  function showLoadError(err) {
    var host = $("#scanner-load-error");
    if (host) {
      host.hidden = false;
      host.textContent =
        "Scanner data could not be loaded. Check that /data/*.json is available. " +
        (err && err.message ? err.message : "");
    }
  }

  function boot() {
    Promise.all([
      fetchJson(DATA_URLS.scanner),
      fetchJson(DATA_URLS.ati),
      fetchJson(DATA_URLS.tfo),
      fetchJson(DATA_URLS.layers),
    ])
      .then(function (payloads) {
        state.scanner = payloads[0];
        state.ati = payloads[1];
        state.tfo = payloads[2];
        state.layers = payloads[3];
        state.tfoById = buildTfoRegistry(state.tfo);
        state.layerById = indexRegistry(state.layers.layers, "id");
        state.vectorMeta = buildVectorMeta({ vectors: state.ati.vectors || [] });
        initWizard();
      })
      .catch(showLoadError);
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
