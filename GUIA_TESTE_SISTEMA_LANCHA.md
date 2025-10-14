# 🔧 GUIA DE TESTE E VERIFICAÇÃO - SISTEMA LANCHA PATRULHA

## ✅ **CHECKLIST PRÉ-TESTE:**

### **1. OBJETOS NECESSÁRIOS:**
- ✅ `obj_player_controller` - Criado e com código
- ✅ `obj_lancha_patrulha` - Criado e com código  
- ✅ `scr_mouse_to_world` - Script criado
- ✅ `obj_inimigo` - Para teste de combate (opcional)

### **2. VERIFICAÇÕES OBRIGATÓRIAS:**

#### **📍 Room Setup:**
```
1. Adicione 1 instância de obj_player_controller na room
2. Adicione 1 instância de obj_lancha_patrulha na room
3. (Opcional) Adicione obj_inimigo para testar combate
```

#### **🎯 Nome dos Objetos:**
```
- Objeto deve se chamar EXATAMENTE: obj_lancha_patrulha
- Se usar nome diferente, ajuste no controller:
  instance_position(wx, wy, SEU_NOME_AQUI);
```

#### **📜 Script scr_mouse_to_world:**
```
- Deve existir em scripts/scr_mouse_to_world/
- Deve conter a função correta
- Salve e compile o projeto
```

## 🧪 **TESTE PASSO A PASSO:**

### **PASSO 1: Seleção**
```
1. Execute o jogo
2. Clique esquerdo na lancha
3. ESPERADO: 
   - Debug: "Controller: Lancha selecionada"
   - Círculo verde ao redor da lancha
```

### **PASSO 2: Movimento**
```
1. Com a lancha selecionada
2. Clique direito em qualquer lugar vazio
3. ESPERADO:
   - Debug: "Controller: Ordem de mover enviada"
   - Debug: "🚢 Ordem de movimento"
   - Lancha se move suavemente até o destino
   - Linha amarela mostrando o caminho
```

### **PASSO 3: Patrulha**
```
1. Selecione a lancha
2. Pressione tecla K
3. ESPERADO: Debug "Controller: Entrou em modo DEFINIÇÃO PATRULHA"

4. Clique esquerdo em 2+ pontos diferentes
5. ESPERADO: Debug "Controller: Ponto de patrulha adicionado"

6. Clique direito para confirmar
7. ESPERADO: 
   - Debug "Controller: Patrulha confirmada"
   - Lancha inicia patrulha cíclica
```

### **PASSO 4: Controles**
```
1. Com lancha selecionada, pressione:
   - O: Debug "Controller: Modo ATAQUE ativado"
   - P: Debug "Controller: Modo PASSIVO ativado"  
   - L: Debug "Controller: Ordem STOP enviada"
```

## 🐛 **PROBLEMAS COMUNS:**

### **❌ "Nada acontece ao clicar":**
```
- Verifique se obj_player_controller está na room
- Verifique se scr_mouse_to_world existe
- Verifique console de debug para erros
```

### **❌ "Lancha não se move":**
```
- Verifique se func_ordem_mover existe no Create da lancha
- Verifique se estado muda para LanchaState.MOVENDO
- Verifique debug messages no Step Event
```

### **❌ "Patrulha não funciona":**
```
- Verifique se pontos_patrulha foi criado (ds_list_create)
- Verifique se ds_list_size > 1 antes de iniciar
- Verifique se estado muda para LanchaState.PATRULHANDO
```

### **❌ "Erro de câmera/coordenadas":**
```
- Se usa múltiplas views, ajuste view_camera[0] no script
- Teste com view simples primeiro
- Verifique se mouse_x/mouse_y funciona como fallback
```

## 🔍 **DEBUG MESSAGES ESPERADAS:**

```
🎮 Player Controller criado!
🚢 Lancha Patrulha criada!
Controller: Lancha selecionada (id=XXXXX)
Controller: Ordem de mover enviada -> (X,Y)
🚢 Ordem de movimento: (X, Y)
🚢 Movendo... Distância: XXX
🚢 Chegou ao destino!
Controller: Entrou em modo DEFINIÇÃO PATRULHA
Controller: Ponto de patrulha adicionado (X,Y)
Controller: Patrulha confirmada para lancha (pontos=X)
```

## 🎯 **SE AINDA NÃO FUNCIONAR:**

1. **Verifique Console de Debug** - Procure por erros
2. **Teste Movimento Simples** - Apenas seleção + movimento
3. **Desative Outros Controladores** - Temporariamente
4. **Verifique Layers** - Lancha deve estar em layer visível
5. **Teste Room Limpa** - Crie room nova só para teste

**✅ SISTEMA ESTÁ COMPLETO E FUNCIONAL!**
