{%- if theme.google_analytics.tracking_id %}
  <script async src="https://www.googletagmanager.com/gtag/js?id={{ theme.google_analytics.tracking_id }}"></script>
  <script{{ pjax }}>
    if (CONFIG.hostname === location.hostname) {
      window.dataLayer = window.dataLayer || [];
      function gtag(){ dataLayer.push(arguments); }

      gtag('js', new Date());

      {%- if not theme.google_analytics.only_pageview %}
        gtag('config', '{{ theme.google_analytics.tracking_id }}');
      {%- else %}
        gtag('config', '{{ theme.google_analytics.tracking_id }}', {
          send_page_view: false
        });

        function sendPageView() {
          if (CONFIG.hostname !== location.hostname) return;
          gtag('event', 'page_view', {
            page_title: document.title,
            page_location: location.href,
            page_path: location.pathname + location.search
          });
        }

        document.addEventListener('pjax:complete', sendPageView);
        sendPageView();
      {%- endif %}
    }
  </script>
{%- endif %}