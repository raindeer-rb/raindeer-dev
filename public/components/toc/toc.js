const toc = document.querySelector('details#toc');
const minWidth = window.matchMedia('(min-width: 1024px)');

function toggleTOC(e) {
  if (e.matches) {
    toc.setAttribute('open', '');
  } else {
    toc.removeAttribute('open');
  }
}

minWidth.addEventListener('change', toggleTOC);
toggleTOC(minWidth);
