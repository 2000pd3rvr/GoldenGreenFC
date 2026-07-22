---
title: Golden Green SC
emoji: ⚽
colorFrom: green
colorTo: yellow
sdk: static
app_file: index.html
pinned: false
license: mit
short_description: Golden Green Sporting Club — Dream Big, Do More (Est. 2012)
---

# Golden Green Sporting Club

**Version:** 1.0.1

Official club website for **Golden Green Sporting Club** — motto *Dream Big, Do More*, established **2012**.

Built from the club’s public social presence:

- Instagram: [@golden_green_sportingclub](https://instagram.com/golden_green_sportingclub)
- Facebook: [@goldengreensporting.club](https://www.facebook.com/goldengreensporting.club)
- TikTok: [training clip](https://vm.tiktok.com/ZMkjbv63E/)

## Live

- **Hugging Face Space:** https://huggingface.co/spaces/0001AMA/GoldenGreenFC  
- **Static site:** https://0001ama-goldengreenfc.static.hf.space/  
- **GitHub:** https://github.com/2000pd3rvr/GoldenGreenFC  

## Local preview

```bash
cd /Users/pd3rvr/Documents/TCS/GoldenGreenFC
python3 -m http.server 8765
# open http://localhost:8765
```

## Versioning

Each public deployment is a new sub-version (`1.0.0`, `1.0.1`, …).

```bash
# bump patch (default), sync files, commit, tag, push GH + HF
./scripts/deploy.sh
# or minor / major
./scripts/deploy.sh minor
```
