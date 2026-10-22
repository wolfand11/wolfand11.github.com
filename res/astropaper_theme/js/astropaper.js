/*
 * AstroPaper theme for org-mode html export.
 * Visual design follows https://github.com/satnaing/astro-paper
 *
 * The initial `data-theme` attribute is set by an inline script in <head>
 * (see wolfand11-org-html-head-astropaper-theme) so the page never flashes
 * the wrong color scheme. This script handles everything after that.
 *
 * Optional overrides: define `window.ASTROPAPER_CONFIG = {...}` before this
 * script is loaded.
 */
(function () {
  "use strict";

  var DEFAULTS = {
    siteTitle: "wolfand11",
    author: "wolfand11",
    homeUrl: "",
    nav: [
      { label: "Posts", href: "sitemap.html" },
      { label: "Projects", href: "projects.html" },
      { label: "About", href: "about.html" }
    ],
    socials: [
      { label: "GitHub", href: "https://github.com/wolfand11", icon: "github" }
    ],
    tocLabel: "Table of contents",
    goBackLabel: "Go back",
    updatedLabel: "Updated",
    backToTopLabel: "Back to top",
    copyLabel: "Copy",
    copiedLabel: "Copied",
    mermaidUrl: "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs"
  };

  var config = Object.assign({}, DEFAULTS, window.ASTROPAPER_CONFIG || {});

  var THEME_KEY = "theme";
  var THEME_EVENT = "astropaper:themechange";
  var WIDE_TOC_QUERY = "(min-width: 1400px)";

  var root = document.documentElement;
  var currentScript = document.currentScript;
  var darkQuery = window.matchMedia("(prefers-color-scheme: dark)");

  var ICONS = {
    sun: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 12m-4 0a4 4 0 1 0 8 0a4 4 0 1 0 -8 0"/><path d="M3 12h1m8 -9v1m8 8h1m-9 8v1m-6.4 -15.4l.7 .7m12.1 -.7l-.7 .7m0 11.4l.7 .7m-12.1 -.7l-.7 .7"/></svg>',
    moon: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 3c.132 0 .263 0 .393 0a7.5 7.5 0 0 0 7.92 12.446a9 9 0 1 1 -8.313 -12.454z"/></svg>',
    menu: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 6l16 0"/><path d="M4 12l16 0"/><path d="M4 18l16 0"/></svg>',
    close: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M18 6l-12 12"/><path d="M6 6l12 12"/></svg>',
    arrowLeft: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 12l14 0"/><path d="M5 12l6 6"/><path d="M5 12l6 -6"/></svg>',
    arrowUp: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 5l0 14"/><path d="M18 11l-6 -6"/><path d="M6 11l6 -6"/></svg>',
    calendar: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7a2 2 0 0 1 2 -2h12a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-12a2 2 0 0 1 -2 -2v-12z"/><path d="M16 3v4"/><path d="M8 3v4"/><path d="M4 11h16"/></svg>',
    github: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 19c-4.3 1.4 -4.3 -2.5 -6 -3m12 5v-3.5c0 -1 .1 -1.4 -.5 -2c2.8 -.3 5.5 -1.4 5.5 -6a4.6 4.6 0 0 0 -1.3 -3.2a4.2 4.2 0 0 0 -.1 -3.2s-1.1 -.3 -3.5 1.3a12.3 12.3 0 0 0 -6.2 0c-2.4 -1.6 -3.5 -1.3 -3.5 -1.3a4.2 4.2 0 0 0 -.1 3.2a4.6 4.6 0 0 0 -1.3 3.2c0 4.6 2.7 5.7 5.5 6c-.6 .6 -.6 1.2 -.5 2v3.5"/></svg>',
    link: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 15l6 -6"/><path d="M11 6l.463 -.536a5 5 0 0 1 7.071 7.072l-.534 .464"/><path d="M13 18l-.397 .534a5.068 5.068 0 0 1 -7.127 0a4.972 4.972 0 0 1 0 -7.071l.524 -.463"/></svg>'
  };

  function h(tag, attrs, html) {
    var node = document.createElement(tag);
    Object.keys(attrs || {}).forEach(function (key) {
      node.setAttribute(key, attrs[key]);
    });
    if (html !== undefined) node.innerHTML = html;
    return node;
  }

  function onReady(fn) {
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", fn);
    } else {
      fn();
    }
  }

  /* ------------------------------------------------------------------ */
  /* Theme                                                              */
  /* ------------------------------------------------------------------ */

  function storedTheme() {
    try {
      var theme = localStorage.getItem(THEME_KEY);
      return theme === "light" || theme === "dark" ? theme : null;
    } catch (e) {
      return null;
    }
  }

  function preferredTheme() {
    return storedTheme() || (darkQuery.matches ? "dark" : "light");
  }

  function currentTheme() {
    return root.getAttribute("data-theme") === "dark" ? "dark" : "light";
  }

  function applyTheme(theme) {
    var changed = root.getAttribute("data-theme") !== theme;
    root.setAttribute("data-theme", theme);

    var meta = document.querySelector('meta[name="theme-color"]');
    if (meta) {
      // Custom properties are not transitioned, so this is the final color.
      var bg = getComputedStyle(root).getPropertyValue("--background").trim();
      if (bg) meta.setAttribute("content", bg);
    }

    var btn = document.getElementById("theme-btn");
    if (btn) {
      var label = theme === "dark" ? "Switch to light theme" : "Switch to dark theme";
      btn.setAttribute("aria-label", label);
      btn.setAttribute("title", label);
    }

    if (changed) {
      document.dispatchEvent(new CustomEvent(THEME_EVENT, { detail: { theme: theme } }));
    }
  }

  function toggleTheme() {
    var next = currentTheme() === "dark" ? "light" : "dark";
    try {
      localStorage.setItem(THEME_KEY, next);
    } catch (e) {
      /* storage unavailable: theme still switches for this page */
    }
    applyTheme(next);
  }

  function watchThemeSources() {
    var onSystemChange = function () {
      if (!storedTheme()) applyTheme(preferredTheme());
    };
    if (darkQuery.addEventListener) {
      darkQuery.addEventListener("change", onSystemChange);
    } else if (darkQuery.addListener) {
      darkQuery.addListener(onSystemChange);
    }
    // Keep other open tabs in sync.
    window.addEventListener("storage", function (event) {
      if (event.key === THEME_KEY) applyTheme(preferredTheme());
    });
  }

  /* ------------------------------------------------------------------ */
  /* Site urls                                                          */
  /* ------------------------------------------------------------------ */

  function withTrailingSlash(url) {
    return /\/$/.test(url) ? url : url + "/";
  }

  function resolveHomeUrl() {
    if (config.homeUrl) return withTrailingSlash(config.homeUrl);

    var orgHome = document.querySelector('#org-div-home-and-up a[accesskey="H"]');
    if (orgHome && orgHome.getAttribute("href")) return withTrailingSlash(orgHome.href);

    if (currentScript && currentScript.src) {
      var match = currentScript.src.match(/^(.*\/)res\/astropaper_theme\/js\/astropaper\.js/);
      if (match) return match[1];
    }
    return withTrailingSlash(location.origin);
  }

  function normalizePath(pathname) {
    return decodeURIComponent(pathname).replace(/\/index\.html$/, "/").replace(/\/$/, "") || "/";
  }

  function isSamePage(url) {
    try {
      var target = new URL(url, location.href);
      return target.host === location.host && normalizePath(target.pathname) === normalizePath(location.pathname);
    } catch (e) {
      return false;
    }
  }

  /* ------------------------------------------------------------------ */
  /* Layout: header / footer                                            */
  /* ------------------------------------------------------------------ */

  function buildHeader(homeUrl) {
    var header = h("header", { class: "ap-header" });
    header.appendChild(h("a", { id: "skip-to-content", href: "#content" }, "Skip to content"));

    var inner = h("div", { class: "ap-header-inner" });
    inner.appendChild(h("a", { class: "ap-logo", href: homeUrl }, config.siteTitle));

    var menuBtn = h("button", {
      id: "menu-btn",
      class: "ap-icon-btn",
      type: "button",
      "aria-label": "Open Menu",
      "aria-expanded": "false",
      "aria-controls": "ap-menu-items"
    }, '<span class="ap-icon-menu">' + ICONS.menu + '</span><span class="ap-icon-close">' + ICONS.close + "</span>");
    inner.appendChild(menuBtn);

    var nav = h("nav", { class: "ap-nav", "aria-label": "Main" });
    var list = h("ul", { id: "ap-menu-items", class: "ap-menu" });

    config.nav.forEach(function (item) {
      var href = new URL(item.href, homeUrl).href;
      var li = h("li");
      var a = h("a", { href: href }, item.label);
      if (isSamePage(href)) {
        a.classList.add("active");
        a.setAttribute("aria-current", "page");
      }
      li.appendChild(a);
      list.appendChild(li);
    });

    var themeLi = h("li", { class: "ap-menu-theme" });
    var themeBtn = h("button", { id: "theme-btn", class: "ap-icon-btn", type: "button" },
      '<span class="ap-icon-moon">' + ICONS.moon + '</span><span class="ap-icon-sun">' + ICONS.sun + "</span>");
    themeBtn.addEventListener("click", toggleTheme);
    themeLi.appendChild(themeBtn);
    list.appendChild(themeLi);

    nav.appendChild(list);
    inner.appendChild(nav);
    header.appendChild(inner);
    header.appendChild(h("hr", { class: "ap-hr" }));

    menuBtn.addEventListener("click", function () {
      var open = header.classList.toggle("ap-menu-open");
      menuBtn.setAttribute("aria-expanded", open ? "true" : "false");
      menuBtn.setAttribute("aria-label", open ? "Close Menu" : "Open Menu");
    });

    document.body.insertBefore(header, document.body.firstChild);
  }

  function buildFooter() {
    var footer = h("footer", { class: "ap-footer" });
    footer.appendChild(h("hr", { class: "ap-hr" }));
    var inner = h("div", { class: "ap-footer-inner" });

    var socials = h("div", { class: "ap-socials" });
    config.socials.forEach(function (item) {
      socials.appendChild(h("a", {
        href: item.href,
        target: "_blank",
        rel: "noopener noreferrer",
        title: item.label,
        "aria-label": item.label
      }, ICONS[item.icon] || ICONS.link));
    });
    inner.appendChild(socials);

    inner.appendChild(h("div", { class: "ap-copyright" },
      "Copyright &#169; " + new Date().getFullYear() + " " + config.author +
      '<span class="ap-sep" aria-hidden="true">|</span>All rights reserved.'));

    footer.appendChild(inner);
    document.body.appendChild(footer);
  }

  /* ------------------------------------------------------------------ */
  /* Post decorations                                                   */
  /* ------------------------------------------------------------------ */

  function exportDate() {
    // ox-html writes the export time as the first comment in <head>.
    var nodes = document.head.childNodes;
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].nodeType === Node.COMMENT_NODE) {
        var match = nodes[i].nodeValue.match(/(\d{4}-\d{2}-\d{2})/);
        if (match) return match[1];
      }
    }
    return null;
  }

  function decoratePostHeader(content, homeUrl) {
    var title = content.querySelector("h1.title");
    if (!title) return;

    var goBack = h("a", { class: "ap-go-back", href: homeUrl }, ICONS.arrowLeft + "<span>" + config.goBackLabel + "</span>");
    goBack.addEventListener("click", function (event) {
      var sameOrigin = document.referrer && document.referrer.indexOf(location.origin) === 0;
      if (sameOrigin && history.length > 1) {
        event.preventDefault();
        history.back();
      }
    });
    content.insertBefore(goBack, title);

    var date = exportDate();
    if (date) {
      var meta = h("div", { class: "ap-post-meta" },
        ICONS.calendar + "<span>" + config.updatedLabel + ':</span> <time datetime="' + date + '">' + date + "</time>");
      var anchor = title.nextElementSibling && title.nextElementSibling.classList.contains("subtitle")
        ? title.nextElementSibling
        : title;
      anchor.insertAdjacentElement("afterend", meta);
    }
  }

  function addHeadingLinks(content) {
    var headings = content.querySelectorAll("h2[id], h3[id], h4[id], h5[id], h6[id]");
    Array.prototype.forEach.call(headings, function (heading) {
      var link = h("a", {
        class: "heading-link",
        href: "#" + heading.id,
        "aria-label": "Link to this section"
      }, "#");
      heading.appendChild(link);
    });
  }

  function wrapTables(content) {
    Array.prototype.forEach.call(content.querySelectorAll("table"), function (table) {
      if (table.parentElement.classList.contains("ap-table-wrapper")) return;
      var wrapper = h("div", { class: "ap-table-wrapper" });
      table.parentNode.insertBefore(wrapper, table);
      wrapper.appendChild(table);
    });
  }

  function copyText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text);
    }
    return new Promise(function (resolve, reject) {
      var area = h("textarea", { class: "ap-copy-buffer", readonly: "" });
      area.value = text;
      document.body.appendChild(area);
      area.select();
      var ok = false;
      try {
        ok = document.execCommand("copy");
      } catch (e) {
        ok = false;
      }
      document.body.removeChild(area);
      if (ok) resolve(); else reject(new Error("copy failed"));
    });
  }

  function enhanceCodeBlocks(content) {
    var blocks = content.querySelectorAll("pre.src, pre.example");
    Array.prototype.forEach.call(blocks, function (pre) {
      var wrapper = h("div", { class: "ap-code-block" });
      pre.parentNode.insertBefore(wrapper, pre);
      wrapper.appendChild(pre);

      var toolbar = h("div", { class: "ap-code-toolbar" });
      var langMatch = pre.className.match(/\bsrc-([\w+#.-]+)/);
      if (langMatch) toolbar.appendChild(h("span", { class: "ap-code-lang" }, langMatch[1]));

      var btn = h("button", { class: "ap-copy-btn", type: "button" }, config.copyLabel);
      btn.addEventListener("click", function () {
        copyText(pre.innerText.replace(/\n$/, "")).then(function () {
          btn.textContent = config.copiedLabel;
          btn.classList.add("copied");
          setTimeout(function () {
            btn.textContent = config.copyLabel;
            btn.classList.remove("copied");
          }, 1500);
        }, function () {
          btn.textContent = "Error";
        });
      });
      toolbar.appendChild(btn);
      wrapper.appendChild(toolbar);
    });
  }

  /* ------------------------------------------------------------------ */
  /* Table of contents                                                  */
  /* ------------------------------------------------------------------ */

  function buildToc() {
    var orgToc = document.getElementById("table-of-contents");
    var list = document.getElementById("text-table-of-contents");
    if (!orgToc || !list) return null;

    var details = h("details", { id: "table-of-contents", class: "ap-toc", role: "doc-toc" });
    details.appendChild(h("summary", {}, config.tocLabel));
    details.appendChild(list);
    orgToc.parentNode.replaceChild(details, orgToc);

    var wideQuery = window.matchMedia(WIDE_TOC_QUERY);
    var syncMode = function () {
      if (wideQuery.matches) details.open = true;
    };
    syncMode();
    if (wideQuery.addEventListener) wideQuery.addEventListener("change", syncMode);
    else if (wideQuery.addListener) wideQuery.addListener(syncMode);

    var links = Array.prototype.slice.call(list.querySelectorAll('a[href^="#"]'));
    var entries = links.map(function (link) {
      var id = decodeURIComponent(link.getAttribute("href").slice(1));
      return { link: link, target: document.getElementById(id) };
    }).filter(function (entry) {
      return entry.target;
    });

    return { details: details, list: list, entries: entries, wideQuery: wideQuery, active: null };
  }

  function updateTocHighlight(toc) {
    if (!toc || !toc.entries.length) return;
    var offset = 120;
    var current = null;
    for (var i = 0; i < toc.entries.length; i++) {
      if (toc.entries[i].target.getBoundingClientRect().top - offset <= 0) {
        current = toc.entries[i];
      } else {
        break;
      }
    }
    if (current === toc.active) return;
    if (toc.active) toc.active.link.classList.remove("active");
    toc.active = current;
    if (!current) return;
    current.link.classList.add("active");

    if (toc.wideQuery.matches) {
      var box = toc.details;
      var linkTop = current.link.offsetTop;
      if (linkTop < box.scrollTop + 40 || linkTop > box.scrollTop + box.clientHeight - 40) {
        box.scrollTop = linkTop - box.clientHeight / 3;
      }
    }
  }

  /* ------------------------------------------------------------------ */
  /* Scroll widgets                                                     */
  /* ------------------------------------------------------------------ */

  function buildScrollWidgets(toc) {
    var progress = h("div", { class: "ap-progress", "aria-hidden": "true" }, '<div class="ap-progress-bar"></div>');
    var bar = progress.firstChild;
    document.body.appendChild(progress);

    var backToTop = h("button", {
      class: "ap-back-to-top",
      type: "button",
      "aria-label": config.backToTopLabel,
      title: config.backToTopLabel
    }, ICONS.arrowUp);
    backToTop.addEventListener("click", function () {
      window.scrollTo({ top: 0, behavior: "smooth" });
      var skip = document.getElementById("skip-to-content");
      if (skip) skip.focus({ preventScroll: true });
    });
    document.body.appendChild(backToTop);

    var ticking = false;
    var update = function () {
      ticking = false;
      var doc = document.documentElement;
      var max = doc.scrollHeight - doc.clientHeight;
      var ratio = max > 0 ? Math.min(1, window.scrollY / max) : 0;
      bar.style.transform = "scaleX(" + ratio + ")";
      backToTop.classList.toggle("visible", window.scrollY > 600);
      updateTocHighlight(toc);
    };
    var schedule = function () {
      if (!ticking) {
        ticking = true;
        window.requestAnimationFrame(update);
      }
    };
    window.addEventListener("scroll", schedule, { passive: true });
    window.addEventListener("resize", schedule);
    update();
  }

  /* ------------------------------------------------------------------ */
  /* Mermaid                                                            */
  /* ------------------------------------------------------------------ */

  function initMermaid() {
    var nodes = Array.prototype.slice.call(document.querySelectorAll("pre.mermaid"));
    if (!nodes.length) return;

    nodes.forEach(function (node) {
      node.setAttribute("data-ap-source", node.textContent);
    });

    var loaded = import(config.mermaidUrl).then(function (module) {
      return module.default;
    });
    var queue = Promise.resolve();

    var render = function () {
      queue = queue.then(function () {
        return loaded;
      }).then(function (mermaid) {
        mermaid.initialize({
          startOnLoad: false,
          theme: currentTheme() === "dark" ? "dark" : "default"
        });
        nodes.forEach(function (node) {
          node.removeAttribute("data-processed");
          node.textContent = node.getAttribute("data-ap-source");
        });
        return mermaid.run({ nodes: nodes });
      }).catch(function (err) {
        console.error("[astropaper] mermaid render failed:", err);
      });
    };

    render();
    document.addEventListener(THEME_EVENT, render);
  }

  /* ------------------------------------------------------------------ */
  /* Init                                                               */
  /* ------------------------------------------------------------------ */

  function init() {
    if (!root.getAttribute("data-theme")) root.setAttribute("data-theme", preferredTheme());
    root.classList.add("astropaper");

    var homeUrl = resolveHomeUrl();
    var content = document.getElementById("content");

    buildHeader(homeUrl);
    applyTheme(currentTheme());
    watchThemeSources();

    var toc = null;
    if (content) {
      if (!isSamePage(homeUrl)) decoratePostHeader(content, homeUrl);
      toc = buildToc();
      addHeadingLinks(content);
      wrapTables(content);
      enhanceCodeBlocks(content);
    }

    buildFooter();
    buildScrollWidgets(toc);
    initMermaid();

    // blog-tools.js runs in <head> before the body exists; run it again now.
    if (typeof window.init_blog_tools === "function") window.init_blog_tools();

    // Enable color transitions only after first paint so loading never animates.
    window.requestAnimationFrame(function () {
      root.classList.add("ap-ready");
    });
  }

  onReady(init);
})();
