# Security policy / Política de segurança

## English

Do not disclose vulnerabilities, credentials, private repository data, or working
exploits in public issues.

Report security concerns through GitHub's private vulnerability reporting
("Security" tab → "Report a vulnerability") when enabled. If it is unavailable,
contact the repository owner privately through the channel listed on the
`ecodelearn` GitHub profile.

Include the affected commit, operating system, reproduction steps, expected
impact, and a minimal proof of concept without real secrets. This template ships
hooks (`.claude/hooks/`) and adoption scripts (`adopt.sh`, `adopt.ps1`) that run
on your machine, so issues in them are in scope.

Maintainers will acknowledge the report, assess severity, prepare a fix and
coordinate disclosure. No guaranteed response SLA is offered.

Supported code is the current `master` branch.

## Português do Brasil

Não divulgue vulnerabilidades, credenciais, dados de repositórios privados ou
exploits funcionais em issues públicas.

Use o reporte privado de vulnerabilidade do GitHub (aba "Security" → "Report a
vulnerability") quando habilitado. Se indisponível, contate o responsável de
forma privada pelo canal indicado no perfil GitHub `ecodelearn`.

Inclua commit afetado, sistema operacional, passos de reprodução, impacto
esperado e uma prova mínima sem segredos reais. Este template inclui hooks
(`.claude/hooks/`) e scripts de adoção (`adopt.sh`, `adopt.ps1`) que rodam na sua
máquina, então problemas neles estão no escopo.

Os mantenedores confirmarão o recebimento, avaliarão severidade, prepararão a
correção e coordenarão divulgação. Não há SLA garantido.

O código suportado é a branch `master`.
