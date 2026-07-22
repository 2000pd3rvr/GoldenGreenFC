(() => {
  const VERSION = "1.0.2";
  // Optional: set window.GGFC_ADMIN_EMAIL before this script to enable mailto forwarding.
  const ADMIN_EMAIL =
    (typeof window !== "undefined" && window.GGFC_ADMIN_EMAIL) || "";

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
    ".about .section-rail, .facts, .spirit-visual, .spirit-copy, .connect .eyebrow, .connect h2, .connect .section-lead, .social-list, .collaborate .eyebrow, .collaborate h2, .collaborate .section-lead, .collaborate-grid"
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

  const form = document.getElementById("collaborateForm");
  const status = document.getElementById("collaborateFormStatus");
  if (form && status) {
    form.addEventListener("submit", (event) => {
      event.preventDefault();
      const name = form.name.value.trim();
      const organisation = form.organisation.value.trim();
      const email = form.email.value.trim();
      const type = form.type.value;
      const message = form.message.value.trim();

      if (!name || !email || !type || !message) {
        status.textContent = "Please complete the required fields.";
        status.dataset.state = "error";
        return;
      }

      const subject = encodeURIComponent(`Golden Green collaboration: ${type}`);
      const body = encodeURIComponent(
        [
          `Name: ${name}`,
          `Organisation: ${organisation || "—"}`,
          `Email: ${email}`,
          `Type: ${type}`,
          "",
          message,
        ].join("\n")
      );

      if (ADMIN_EMAIL) {
        window.location.href = `mailto:${ADMIN_EMAIL}?subject=${subject}&body=${body}`;
        status.textContent = "Opening your email app to send the enquiry…";
        status.dataset.state = "ok";
      } else {
        status.textContent =
          "Thanks — your enquiry is ready. Add an admin email (window.GGFC_ADMIN_EMAIL) to enable direct send, or message the club on Instagram / Facebook.";
        status.dataset.state = "ok";
      }
    });
  }
})();
