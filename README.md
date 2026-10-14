# CP05 — Pipeline DevSecOps completo (Arcanjo SA)

**Aluno:** Gabriel Diegues Figueiredo Rocha · **RM:** 550788 · **Turma:** 4ESPV

Evolução do portal do CP04 (nginx alpine servindo `index.html`) com um pipeline de segurança
obrigatório no GitHub Actions (`.github/workflows/security.yml`), com 3 barreiras:

| Job | Ferramenta | Barra |
|---|---|---|
| `gitleaks` | Gitleaks | segredos em qualquer commit do histórico |
| `semgrep` | Semgrep (SAST) | código vulnerável, ex.: `eval()` com entrada do usuário |
| `trivy` | Trivy | imagem Docker com CVE `CRITICAL` (com correção disponível) |

## Provas (testes de sabotagem)

Cada barreira tem um Pull Request que a faz falhar; a `main` fica verde.

| Prova | Branch | Resultado esperado |
|---|---|---|
| 1 — segredo falso | `sabotagem/gitleaks` | job `gitleaks` vermelho |
| 2 — `eval` | `sabotagem/semgrep` | job `semgrep` vermelho |
| 3 — imagem com CVE | `sabotagem/trivy` (base `nginx:1.27-alpine`: 2 CRITICAL, OpenSSL CVE-2026-31789) | job `trivy` vermelho; na `main` (`nginx:1.30-alpine`) fica verde |

## Reproduzir localmente

```bash
docker build -t cp05-arcanjo:local .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --severity CRITICAL cp05-arcanjo:local
docker run --rm -v "$PWD":/src zricethezav/gitleaks detect --source /src
docker run --rm -v "$PWD":/src semgrep/semgrep semgrep scan --config p/javascript --config p/security-audit --error /src
```
