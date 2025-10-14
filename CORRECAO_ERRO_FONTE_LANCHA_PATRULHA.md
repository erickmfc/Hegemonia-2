🔧 CORREÇÃO DE ERRO - LANCHA PATRULHA v4.0
==========================================

❌ ERRO IDENTIFICADO:
Variable <unknown_object>.hegemonia_main(101338, -2147483648) not set before reading it.

✅ CORREÇÃO APLICADA:
- Alterado `hegemonia_main` para `fnt_ui_main` no arquivo Draw_GUI_0.gml
- Limpado código duplicado no Draw_64.gml
- Fonte correta identificada: fnt_ui_main (disponível em fonts/fnt_ui_main/)

📋 DETALHES DA CORREÇÃO:
- Linha 27 do Draw_GUI_0.gml: draw_set_font(fnt_ui_main);
- Draw_64.gml: Limpo e documentado como arquivo vazio
- Código da interface mantido apenas no Draw_GUI_0.gml

🎯 RESULTADO:
- Erro de fonte resolvido
- Interface funcionando corretamente
- Código organizado e sem duplicação

✅ STATUS: CORREÇÃO CONCLUÍDA COM SUCESSO!
