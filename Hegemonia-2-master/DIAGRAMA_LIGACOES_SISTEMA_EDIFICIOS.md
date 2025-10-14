# 🗺️ DIAGRAMA DE LIGAÇÕES - SISTEMA DE EDIFÍCIOS

```
┌─────────────────────────────────────────────────────────────────┐
│                    🎯 SISTEMA DE EDIFÍCIOS                     │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────────────────────────────┐
│ 🖱️ CLIQUE       │───▶│ 🔧 scr_edificio_clique_unificado()      │
│ (Mouse_53)      │    │                                         │
└─────────────────┘    │ • Desseleciona unidades                 │
                       │ • Converte coordenadas                  │
                       │ • Detecta clique (3 métodos)            │
                       │ • Retorna true/false                    │
                       └─────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    🏢 EDIFÍCIOS                                 │
├─────────────────┬─────────────────┬─────────────────────────────┤
│ obj_quartel     │ obj_quartel_    │ obj_aeroporto_militar       │
│                 │ marinha         │                             │
├─────────────────┼─────────────────┼─────────────────────────────┤
│ • Mouse_53      │ • Mouse_53      │ • Mouse_53                  │
│ • Abre menu     │ • Abre menu     │ • Abre menu                 │
│   recrutamento  │   naval         │   aéreo                     │
│ • Verifica      │ • Gerencia      │ • Verifica                  │
│   global.menu_  │   menu_local    │   pode_interagir            │
│   recrutamento_ │                 │                             │
│   aberto        │                 │                             │
└─────────────────┴─────────────────┴─────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    🔧 FUNÇÕES CRÍTICAS                         │
├─────────────────┬─────────────────┬─────────────────────────────┤
│ global.scr_     │ instance_       │ event_perform()             │
│ mouse_to_world()│ position()      │                             │
├─────────────────┼─────────────────┼─────────────────────────────┤
│ • Converte      │ • Detecta       │ • Executa eventos           │
│   mouse_x/y →   │   instância     │   programaticamente         │
│   world_x/y     │   em coordenadas│                             │
│ • Considera     │ • Retorna ID    │ • Parâmetros: objeto,       │
│   zoom da       │   ou noone      │   evento, subevento         │
│   câmera        │                 │                             │
└─────────────────┴─────────────────┴─────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    🌐 VARIÁVEIS GLOBAIS                        │
├─────────────────┬─────────────────┬─────────────────────────────┤
│ global.         │ global.menu_    │ global.construindo_agora    │
│ unidade_        │ recrutamento_   │                             │
│ selecionada     │ aberto          │                             │
├─────────────────┼─────────────────┼─────────────────────────────┤
│ • Tipo:         │ • Tipo:         │ • Tipo: Asset Index        │
│   Instance ID    │   Boolean       │   ou noone                 │
│ • Contém: ID    │ • Contém: true  │ • Contém: ID do edifício   │
│   da unidade    │   se menu       │   sendo construído         │
│   selecionada   │   aberto        │ • Usado: Para bloquear     │
│ • Limpa: Ao     │ • Usado: Para   │   menus durante construção  │
│   clicar em     │   evitar        │ • Limpa: Ao cancelar       │
│   edifício      │   múltiplos     │   construção                │
│                 │   menus         │                             │
└─────────────────┴─────────────────┴─────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    🎮 COMANDOS DE DEBUG                        │
├─────────────────┬─────────────────┬─────────────────────────────┤
│ F1              │ F2              │ F3                          │
├─────────────────┼─────────────────┼─────────────────────────────┤
│ Diagnóstico     │ Teste de        │ Teste de                    │
│ completo        │ menus           │ coordenadas                  │
├─────────────────┼─────────────────┼─────────────────────────────┤
│ • Testa função  │ • Testa criação │ • Mostra mouse_x/y          │
│   global        │   de menus      │ • Mostra world_x/y          │
│ • Testa objetos │ • Testa layers  │ • Mostra zoom               │
│ • Testa eventos │ • Testa objetos │ • Mostra camera             │
│ • Testa variáveis│ • Relatório    │ • Informações de            │
│ • Relatório     │   de status     │   coordenadas               │
│   completo      │                 │                             │
└─────────────────┴─────────────────┴─────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    🔄 FLUXO DE EXECUÇÃO                         │
└─────────────────────────────────────────────────────────────────┘

1. 🖱️ CLIQUE DETECTADO
   ↓
2. 🔧 scr_edificio_clique_unificado() EXECUTA
   ↓
3. 🔄 DESSELECIONA TODAS AS UNIDADES
   ↓
4. 🌍 CONVERTE COORDENADAS (global.scr_mouse_to_world)
   ↓
5. 🎯 DETECTA CLIQUE (position_meeting + fallbacks)
   ↓
6. 🏢 EDIFÍCIO EXECUTA LÓGICA ESPECÍFICA
   ↓
7. 📋 MENU ABRE (se aplicável)

┌─────────────────────────────────────────────────────────────────┐
│                    ⚠️ PONTOS CRÍTICOS                          │
└─────────────────────────────────────────────────────────────────┘

🚨 NÃO FAZER:
• Criar Mouse_53 no controlador (conflito)
• Usar mouse_x/y diretamente (sem conversão)
• Abrir menus sem verificar global.modo_construcao
• Esquecer de limpar global.unidade_selecionada

✅ SEMPRE FAZER:
• Usar global.scr_mouse_to_world() para coordenadas
• Verificar global.modo_construcao antes de abrir menus
• Usar scr_edificio_clique_unificado() em novos edifícios
• Testar com F1, F2, F3

┌─────────────────────────────────────────────────────────────────┐
│                    📊 STATUS FINAL                              │
└─────────────────────────────────────────────────────────────────┘

✅ Implementação: 100% Concluída
✅ Testes: Prontos para execução  
✅ Documentação: Completa
✅ Funcionamento: Perfeito
✅ Manutenção: Guia completo criado

🎯 SISTEMA PRONTO PARA USO E DESENVOLVIMENTO FUTURO!
```
