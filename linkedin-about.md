# LinkedIn "About" section

Last updated 2026-09-02, from a survey of commits across `c:\dev` since 2025-09-01.

---

Full stack data scientist.

I build AI systems that make it into production — the agents, the retrieval layer underneath them, the API, the interface people actually click, and the pipeline that keeps the data fresh. Over the last year that has mostly meant multi-agent systems and MCP servers behind enterprise chat surfaces, RAG over messy source documents, and the evals that tell you whether a change made anything better.

Preferred tools: Python, FastAPI and Pydantic for backends, packaged with uv. React, TypeScript, Vite and Tailwind for the front — Streamlit only for prototypes now. Google ADK and MCP for agents, with Azure OpenAI, Gemini, Mistral and Claude routed through LiteLLM. Qdrant and pgvector for retrieval, dense plus BM25 where it earns its keep. DuckDB and Parquet for analysis. Docker on Azure Container Apps, App Service or Cloud Run, with Bicep when it has to be reproducible. GitHub Actions for anything on a schedule. Quarto for the write-up.

Some of it is not language models at all: YOLO and OCR pipelines for reading documents and camera frames, scikit-learn and LightGBM where a small model is the honest answer.

I work with coding agents daily — Claude Code, Copilot, Gemini CLI — driven from instructions checked into the repo rather than retyped every session.

---

## What changed, and why

The previous version was written before October 2025:

> Full stack data scientist.
> Preferred tools: Python for data wrangling, R for visualisation, SQLite for read only databases, OpenAI API for formatting unstructured data, Google Cloud Functions and GitHub Actions for ML Ops.

Three of those five claims no longer match the commit history.

| Dropped | Why |
| --- | --- |
| R for visualisation | R survives in three `capture-screenshots.R` files using `webshot2` to screenshot Quarto decks. The last real R analysis is the 2021 `.Rmd` posts on jonathanjayes.com. Charts now come from Plotly, Recharts, matplotlib/seaborn, Altair and Leaflet. |
| SQLite for read-only databases | One `import sqlite3` across the whole estate. Replaced by DuckDB + Parquet (malmo-homes-streamlit, westbrook-cars, SARS-trade-app), Qdrant (NEXER_MVP), Postgres/pgvector (Eneo, Greenwashing) and Cosmos DB (holidays). |
| Google Cloud Functions | Zero occurrences. Deployment is Cloud Run and Azure Container Apps / App Service / ACR, with Bicep and Docker Compose. |

Kept: Python for data wrangling (pandas, pyarrow, numpy in 18 repos; polars in two), GitHub Actions for scheduled work (7 workflows in malmo-homes-streamlit alone), and LLM APIs for unstructured data — now Azure OpenAI as the enterprise default alongside Gemini, OpenAI, Mistral and Claude.

Added, because it was the bulk of the year's work and was missing entirely: Google ADK and MCP servers, Copilot Studio as a delivery surface, RAG and retrieval engineering, evals, FastAPI/Pydantic/uv backends, React frontends, Azure and GCP deployment, and working from checked-in agent instructions.

## Trimming notes

If the space runs short, cut the fourth paragraph (YOLO / OCR / scikit-learn) — it is the least central strand.
