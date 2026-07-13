#!/usr/bin/env python3
# inject-jsonld.py
# Sprint 14 - Agent-Readability Layer (AGENT-READ-001).
# Governed by: governance/decisions/DECISION_AGENT_READABILITY_LAYER_1_0_RATIFICATION.md
#
# Injects exactly one JSON-LD structured-data block per governed launch route page.
# All entity content is sourced from the governed data registries (/data/*.json)
# and the governed vocabulary table (ASSET_THESIS.md section 7). No new claims.
# Idempotent: an existing JSON-LD block is replaced, never duplicated.
#
# Only the `definition` field of registry entries is embedded. Diagnostic fields
# (symptoms, detection signals) stay out of structured data by policy.

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BASE = "https://aidatanaly.com"
WEBSITE_ID = f"{BASE}/#website"
ORG_ID = f"{BASE}/#organization"
VOCAB_ID = f"{BASE}/#vocabulary"
TFO_SET_ID = f"{BASE}/transition-failure-ontology/#tfo"

JSONLD_RE = re.compile(
    r'[ \t]*<script type="application/ld\+json">.*?</script>\n?', re.S
)

# Governed vocabulary (ASSET_THESIS.md section 7) - canonical short definitions.
VOCAB_TERMS = {
    "/aida-transition-analytics/": (
        "AIDA Transition Analytics",
        None,
        "The discipline of measuring movement between AIDA states.",
    ),
    "/transition-intelligence/": (
        "Transition Intelligence",
        None,
        "The interpretation, prediction, and optimization of funnel movement.",
    ),
    "/measurement-grammar/": (
        "Measurement Grammar",
        None,
        "The use of AIDA as a state-change language, not a rigid linear path.",
    ),
    "/aida-transition-index/": (
        "AIDA Transition Index",
        "ATI",
        "The governed scoring standard for transition health.",
    ),
    "/evidence-confidence/": (
        "Evidence Confidence",
        None,
        "The governed qualifier stating how much evidence supports a diagnostic "
        "score. Evidence Confidence is reported separately from the diagnostic "
        "scale and never inflates a score.",
    ),
}

TRUST_ROUTES = {
    "/methodology/", "/governance/", "/sources/", "/privacy/", "/terms/",
    "/reports/ati-snapshot/",
}


def load(name):
    with open(ROOT / "data" / name, encoding="utf-8") as f:
        return json.load(f)


def page_path(route):
    if route == "/":
        return ROOT / "index.html"
    return ROOT / route.strip("/") / "index.html"


def extract(html, pattern, label, route):
    m = re.search(pattern, html)
    if not m:
        sys.exit(f"FAIL  [{route}] missing {label}")
    return m.group(1).strip()


def webpage_node(route, title, desc):
    url = BASE + route
    return {
        "@type": "WebPage",
        "@id": url,
        "url": url,
        "name": title,
        "description": desc,
        "inLanguage": "en",
        "isPartOf": {"@id": WEBSITE_ID},
    }


def build_graph(route, title, desc, tfo, vectors, layers):
    url = BASE + route
    page = webpage_node(route, title, desc)
    nodes = [page]

    if route == "/":
        nodes = [
            {
                "@type": "Organization",
                "@id": ORG_ID,
                "name": "AIDAtanaly",
                "url": BASE + "/",
                "description": (
                    "AIDAtanaly is a Sohadot Sovereign Asset: the governed "
                    "reference system for AIDA Transition Analytics."
                ),
            },
            {
                "@type": "WebSite",
                "@id": WEBSITE_ID,
                "name": "AIDAtanaly",
                "alternateName": "AIDA Transition Analytics",
                "url": BASE + "/",
                "description": desc,
                "publisher": {"@id": ORG_ID},
            },
            page,
            {
                "@type": "DefinedTermSet",
                "@id": VOCAB_ID,
                "name": "AIDAtanaly Governed Vocabulary",
                "description": (
                    "Category terms introduced and governed by AIDAtanaly for "
                    "AIDA Transition Analytics."
                ),
                "hasDefinedTerm": [
                    {
                        "@type": "DefinedTerm",
                        "name": name,
                        "url": BASE + r,
                    }
                    for r, (name, _, _) in VOCAB_TERMS.items()
                ],
            },
        ]
        page["mainEntity"] = {"@id": VOCAB_ID}

    elif route in VOCAB_TERMS:
        name, code, definition = VOCAB_TERMS[route]
        term = {
            "@type": "DefinedTerm",
            "@id": url + "#term",
            "name": name,
            "description": definition,
            "url": url,
            "inDefinedTermSet": {"@id": VOCAB_ID},
        }
        if code:
            term["termCode"] = code
        nodes.append(term)
        page["mainEntity"] = {"@id": url + "#term"}

    elif route.startswith("/vectors/"):
        v = next(
            v for v in vectors["vectors"]
            if v["canonical_route"] == route
        )
        term = {
            "@type": "DefinedTerm",
            "@id": url + "#term",
            "name": f"{v['code']} — {v['transition_name']}",
            "alternateName": v["transition"],
            "termCode": v["code"],
            "identifier": v["vector_id"],
            "description": v["definition"],
            "url": url,
            "inDefinedTermSet": {"@id": VOCAB_ID},
        }
        nodes.append(term)
        page["mainEntity"] = {"@id": url + "#term"}

    elif route == "/transition-failure-ontology/":
        entries = tfo["failure_modes"] + tfo["diagnostic_constraints"]
        nodes.append({
            "@type": "DefinedTermSet",
            "@id": TFO_SET_ID,
            "name": "Transition Failure Ontology",
            "alternateName": "TFO",
            "description": desc,
            "url": url,
            "hasDefinedTerm": [
                {
                    "@type": "DefinedTerm",
                    "name": e["name"],
                    "identifier": e["id"],
                    "url": BASE + e["canonical_route"],
                }
                for e in entries
            ],
        })
        page["mainEntity"] = {"@id": TFO_SET_ID}

    elif route.startswith("/failure-modes/"):
        entries = tfo["failure_modes"] + tfo["diagnostic_constraints"]
        e = next(x for x in entries if x["canonical_route"] == route)
        nodes.append({
            "@type": "DefinedTerm",
            "@id": url + "#term",
            "name": e["name"],
            "identifier": e["id"],
            "description": e["definition"],
            "url": url,
            "inDefinedTermSet": {"@id": TFO_SET_ID},
        })
        page["mainEntity"] = {"@id": url + "#term"}

    elif route == "/intervention-layers/":
        nodes.append({
            "@type": "DefinedTermSet",
            "@id": url + "#termset",
            "name": "AIDAtanaly Intervention Layers",
            "description": desc,
            "url": url,
            "hasDefinedTerm": [
                {
                    "@type": "DefinedTerm",
                    "name": l["name"],
                    "identifier": l["id"],
                    "url": url,
                }
                for l in layers["layers"]
            ],
        })
        page["mainEntity"] = {"@id": url + "#termset"}

    elif route == "/scanner/":
        nodes.append({
            "@type": "WebApplication",
            "@id": url + "#app",
            "name": "AIDAtanaly Transition Scanner",
            "url": url,
            "description": desc,
            "applicationCategory": "BusinessApplication",
            "operatingSystem": "Any (web browser)",
            "isAccessibleForFree": True,
            "publisher": {"@id": ORG_ID},
        })
        page["mainEntity"] = {"@id": url + "#app"}

    # Trust routes and any remaining page carry the WebPage node only.
    return {"@context": "https://schema.org", "@graph": nodes}


def main():
    tfo = load("tfo-failure-modes.json")
    vectors = load("ati-vectors.json")
    layers = load("intervention-layers.json")

    route_lines = (ROOT / "ROUTE_MAP.md").read_text(encoding="utf-8").splitlines()
    routes = sorted({
        ln.strip() for ln in route_lines
        if re.fullmatch(r"/[a-z0-9\-/\.]*", ln.strip())
        and not ln.strip().endswith(".json")
    })

    changed = 0
    for route in routes:
        path = page_path(route)
        if not path.exists():
            sys.exit(f"FAIL  [{route}] page not found: {path}")
        html = path.read_text(encoding="utf-8")

        title = extract(html, r"<title>([^<]+)</title>", "title", route)
        desc = extract(
            html, r'<meta name="description" content="([^"]+)"',
            "meta description", route,
        )
        canonical = extract(
            html, r'<link rel="canonical" href="([^"]+)"', "canonical", route,
        )
        if canonical != BASE + route:
            sys.exit(f"FAIL  [{route}] canonical mismatch: {canonical}")

        graph = build_graph(route, title, desc, tfo, vectors, layers)
        payload = json.dumps(graph, ensure_ascii=False, separators=(",", ":"))
        block = f'  <script type="application/ld+json">{payload}</script>\n'

        html = JSONLD_RE.sub("", html)
        if "</head>" not in html:
            sys.exit(f"FAIL  [{route}] no </head> tag")
        html = html.replace("</head>", block + "</head>", 1)

        path.write_text(html, encoding="utf-8")
        changed += 1
        print(f"  OK    [{route}] JSON-LD injected")

    print(f"=== Done: {changed} pages carry governed JSON-LD ===")


if __name__ == "__main__":
    main()
