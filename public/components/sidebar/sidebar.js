const details = document.querySelectorAll('aside#sidebar details');
const detailsMinWidth = window.matchMedia('(min-width: 768px)');

function toggleSummary(e) {
  if (e.matches) {
    details.forEach((element) => {
      element.setAttribute('open', '');
    })
  } else {
    details.forEach((element) => {
      element.removeAttribute('open');
    })
  }
}

detailsMinWidth.addEventListener('change', toggleSummary);
toggleSummary(detailsMinWidth);

// Highlight the current page.
// TODO: Do at the template level.
document.querySelectorAll('aside#sidebar a').forEach((link) => {
  if (link.getAttribute('href') === window.location.pathname.replace(/\/$/, '')) {
    link.classList.add('active');
  }
});
