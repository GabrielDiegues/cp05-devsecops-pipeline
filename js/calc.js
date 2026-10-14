// SABOTAGEM (CP05): eval sobre entrada do usuario - o Semgrep deve apontar.
const expr = decodeURIComponent(location.hash.slice(1));
document.getElementById('resultado').textContent = eval(expr);
