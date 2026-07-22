(() => {
  const VERSION = "1.0.0";

  document.querySelectorAll("[data-version]").forEach((el) => {
    el.textContent = `v${VERSION}`;
  });

  const header = document.querySelector("[data-header]");
  const onScroll = () => {
    if (!header) return;
    header.classList.toggle("is-solid", window.scrollY > 24);
  };
  onScroll();
  window.addEventListener("scroll", onScroll, { passive: true });

  const targets = document.querySelectorAll(
    ".about .section-rail, .facts, .spirit-visual, .spirit-copy, .connect .eyebrow, .connect h2, .connect .section-lead, .social-list"
  );
  targets.forEach((el) => el.classList.add("reveal"));

  if ("IntersectionObserver" in window) {
    const io = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-in");
            io.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.18, rootMargin: "0px 0px -8% 0px" }
    );
    targets.forEach((el) => io.observe(el));
  } else {
    targets.forEach((el) => el.classList.add("is-in"));
  }
})();
