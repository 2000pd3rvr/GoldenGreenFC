#!/usr/bin/env python3
"""Golden Green SC — live club site on Streamlit Community Cloud."""

from __future__ import annotations

from pathlib import Path

import streamlit as st

from streamlit_static import render_live_site

HTML = Path(__file__).resolve().parent / "index.html"

st.set_page_config(
    page_title="Golden Green SC · Deborah Akuoko Minka",
    page_icon="⚽",
    layout="wide",
    initial_sidebar_state="collapsed",
)

ABOUT = """
**Golden Green Sporting Club** — Dream Big, Do More. Public club identity and messaging.

- **Live on Streamlit:** this page
- **Source:** [github.com/2000pd3rvr/GoldenGreenFC](https://github.com/2000pd3rvr/GoldenGreenFC)
- **Also on Hugging Face:** [0001AMA/GoldenGreenFC](https://huggingface.co/spaces/0001AMA/GoldenGreenFC)
- **Author:** Deborah Akuoko Minka / Deborah Akuoko-Minka
- [Research site](https://deborahakuokominka.wordpress.com/) · [ORCID](https://orcid.org/0009-0008-6219-154X)
"""

render_live_site(HTML, height=960, about_title="About Golden Green SC", about_md=ABOUT)
