// FlowCV-style resume — narrow date column, wider content column,
// uppercase section headings with a thin rule beneath.

// Font Awesome icon helpers. nixpkgs ships v7, but the @preview/fontawesome
// package hardcodes v6 font names — so we use the v7 fonts directly with
// stable unicode codepoints from https://fontawesome.com/icons.
#let fa-solid(codepoint) = text(
  font: "Font Awesome 7 Free Solid",
  weight: 900,
  codepoint,
)
#let fa-regular(codepoint) = text(
  font: "Font Awesome 7 Free",
  weight: 400,
  codepoint,
)
#let fa-brands(codepoint) = text(
  font: "Font Awesome 7 Brands",
  weight: 400,
  codepoint,
)

#let fa-envelope() = fa-solid("\u{f0e0}")
#let fa-github() = fa-brands("\u{f09b}")
#let fa-link() = fa-solid("\u{f0c1}")
// arrow-up-right-from-square — small external-link indicator
#let fa-extlink() = fa-solid("\u{f08e}")

// Wrap text as a link, followed by a tiny external-link glyph (also linked).
#let extlink(url, body) = {
  link(url)[#body]
  h(0.2em)
  text(size: 0.75em, fill: rgb("#666666"), link(url, fa-extlink()))
}

#set page(
  paper: "a4",
  margin: (x: 1.5cm, y: 1.3cm),
)
// Lato is the FlowCV default; fall back to Helvetica Neue if not installed.
#set text(font: ("Lato", "Helvetica Neue"), size: 10pt, fill: rgb("#1a1a1a"))
#set par(leading: 0.45em)
#set list(indent: 0.6em, body-indent: 0.4em, marker: text(size: 0.85em, "•"), spacing: 0.5em)

// --- Helpers ---
#let section(title) = {
  v(0.5em)
  text(size: 12pt, weight: "bold", title)
  v(-0.35em)
  line(length: 100%, stroke: 0.9pt + rgb("#1a1a1a"))
  v(0.3em)
}

#let entry(date, body) = {
  grid(
    columns: (3.1cm, 1fr),
    column-gutter: 0.5cm,
    row-gutter: 0.2em,
    text(size: 9pt, fill: rgb("#555555"), date), body,
  )
  v(0.4em)
}

#let role(title, org, url: none) = block(spacing: 0pt)[
  #text(weight: "bold", title) \
  #text(fill: rgb("#444444"))[#if url != none { extlink(url, org) } else { org }]
]

// Uniform skill cell — always renders a subtitle line (using a non-breaking
// space when empty) so all rows in the skills grid have identical heights.
// Skill cell — bold name, optional muted subtitle on a second line.
#let skill(name, sub: none) = block(spacing: 0pt)[
  #text(weight: "bold", name)
  #if sub != none [
    \ #text(size: 9pt, fill: rgb("#555555"), sub)
  ]
]

// --- Header ---
#align(center)[
  #text(size: 20pt, weight: "bold")[Karl Kaiser] \
  #v(-0.4em)
  #text(size: 9.5pt)[
    #fa-envelope() #h(0.25em) #link(
      "mailto:karl@kwkaiser.io",
    )[karl\@kwkaiser.io]
    #h(0.6em) #fa-github() #h(0.25em) #link(
      "https://github.com/kwkaiser",
    )[kwkaiser]
    #h(0.6em) #fa-link() #h(0.25em) #link("https://kwkaiser.io")[kwkaiser.io]
  ]
]
#v(0.2em)

// --- Work Experience ---
#section("Work Experience")

#entry("2025 – Present")[
  #role("Senior Software Engineer", "Pallet", url: "https://www.pallet.com/")
  #v(0.55em)
  Building the agent runtime, eval, and observability platform behind Pallet's AI freight & logistics products:
  - Owned the event-driven agent graph runtime + offline simulation engine for LLM workflow eval & regression testing
  - Built E2E observability — OTel tracing, Datadog log/metric pipelines, per-field LLM-extraction accuracy metrics
  - Designed multi-model LLM-consensus PDF extraction with field-level confidence scoring
]

#entry("05/2022 – 05/2025")[
  #role("Senior Software Engineer", "Finch", url: "https://tryfinch.com/")
  #v(0.4em)
  At Finch, I built a unified payroll API (think Plaid, for payroll) with a few key projects being:
  - Genericizing our job-running framework to handle new product scopes
  - Onboarding a net-new benefits product onto our distributed job runner
  - Leading job-runner migrations from monolith → ECS, ECS → EKS
  - Decomposing our job-running system into #extlink("https://temporal.io/", "Temporal")
]

#entry("10/2020 – 05/2022")[
  #role("Data Engineer", "Miltenyi Biotech", url: "https://www.miltenyibiotec.com/US-en/?countryRedirected=1")
  #v(0.4em)
  Built and administered custom lab information system for experiment and instrument tracking & automated data analysis for in-house genome sequencers.
]

// --- Education ---
#section("Education")

#entry("08/2018 – 05/2020")[
  #role("Masters of Science: Computer Science", "University of Vermont")
]

#entry("08/2016 – 05/2019")[
  #role("Bachelors of Science: Neuroscience", "University of Vermont")
]

// --- Publications ---
#section("Publications")

#entry("2020")[
  #extlink("https://dl.acm.org/doi/10.1145/3377930.3389836", text(weight: "bold")[Modeling Wildfires Using Evolutionary Cellular Automata]) \
  _Genetic and Evolutionary Computation Conference (GECCO)_ \
  Created prediction model utilizing agent-based CAs with spread function evolved via symbolic regression.
]

#entry("2020")[
  #extlink("https://arxiv.org/pdf/2009.03977.pdf", text(weight: "bold")[Modeling Wildfire Perimeter Evolution using Deep Neural Networks]) \
  _(Preprint)_ \
  Created data pipeline using USGS and NOAA APIs to collect, clean, and partition datasets to train a CNN to predict wildfire perimeter spread.
]

// --- Skills ---
#section("Skills")

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.55em,
  skill("Python"), skill("Rust"),
  skill("Golang"), skill("SQL / NoSQL"),
  skill("Javascript / Typescript", sub: "Node / Express / Electron / React"),
  skill(
    "DevOps & Development Tools",
    sub: "Linux / Ansible / Kubernetes / Helm",
  ),

  skill("Cloud Platforms"),
  skill(
    "Data Science + ML",
    sub: "Constructing eval sets, prompt iteration, etc",
  ),

  skill(
    "Distributed Systems",
    sub: "Temporal, event-based systems, HTC engines",
  ),
)
