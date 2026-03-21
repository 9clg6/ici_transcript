Anthropic a envoyé ses avocats à OpenCode.

Dax Raad, le créateur d'OpenCode, a résumé la situation :

"we did our best to convince anthropic to support developer choice but they sent lawyers"
(source : https://x.com/thdxr/status/2034730036759339100)

Voici ce qui s'est passé :

Le 9 janvier 2026, Anthropic a silencieusement activé un blocage côté serveur empêchant tout outil tiers d'utiliser les tokens OAuth des abonnements Claude Pro/Max.

Le 19 février, ils ont mis à jour leurs conditions d'utilisation pour l'officialiser : les tokens OAuth des plans Free, Pro et Max ne peuvent être utilisés qu'avec Claude Code et claude.ai. Point final.

Le 19 mars, Dax a mergé le PR #18186 "Remove anthropic references per legal requests" — supprimant le plugin d'auth Anthropic, le system prompt brandé, et les headers Claude Code du projet.

Concrètement, pour utiliser Claude dans OpenCode, il faut désormais passer par l'API avec un paiement au token :
- Opus 4.6 : $5 / MTok en input, $25 / MTok en output
- Sonnet 4.6 : $3 / $15
- Haiku 4.5 : $1 / $5

Contre un forfait à $100/mois (Max) ou $200/mois (Max 20x) auparavant — sans coût au token.

Pourquoi Anthropic fait ça ?

Leur argument officiel : les abonnements sont des produits "loss-leader" réservés à leurs clients first-party. L'API au token, c'est pour le reste.

En clair : si tu peux utiliser ton abonnement Max dans n'importe quel outil, personne ne passe par l'API. Anthropic protège son revenu.

Ce qui est ironique, c'est qu'OpenAI autorise les outils tiers à utiliser les abonnements ChatGPT. Anthropic est le seul à verrouiller.

OpenCode est un projet open-source. Anthropic ne l'est pas — et cette décision montre clairement que le contrôle de l'écosystème prime sur la liberté des développeurs.

---

Sources :
- PR de suppression : https://github.com/anomalyco/opencode/pull/18186
- Discussion Hacker News : https://news.ycombinator.com/item?id=47444748
- Tweet de Dax : https://x.com/thdxr/status/2034730036759339100
- Pricing API Anthropic : https://platform.claude.com/docs/en/docs/about-claude/models
- Conditions d'utilisation : https://www.anthropic.com/legal/consumer-terms
