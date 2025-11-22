# 🏴‍☠️ CONFIGURAÇÃO FINAL - SISTEMA DE PIRATAS

## ⚠️ CRÍTICO: Configuração de Parents no GameMaker

Antes de testar, você **DEVE** configurar os parents dos objetos:

### **Passo 1: Abrir o Projeto no GameMaker**

1. Abra o Editor de Objetos do GameMaker
2. Procure pelos seguintes objetos:
   - `obj_navio_pirata`
   - `obj_navio_pirata2`
   - `obj_navio_pirata3`
   - `obj_navio_carga`

### **Passo 2: Definir Parents**

Para **CADA** um desses objetos, faça:

1. Clique no objeto (ex: `obj_navio_pirata`)
2. Na aba **Criação** ou **Propriedades**, procure por **Parent**
3. Selecione: **`obj_navio_base`**
4. Repita para todos os 4 objetos

**Resultado esperado**:
```
obj_navio_pirata  → Parent: obj_navio_base ✓
obj_navio_pirata2 → Parent: obj_navio_base ✓
obj_navio_pirata3 → Parent: obj_navio_base ✓
obj_navio_carga   → Parent: obj_navio_base ✓
```

---

## ✅ Verificação de Configuração

Após definir os parents, execute o jogo e verifique no console:

### **Mensagens Esperadas**:

```
🏴‍☠️ Pilar Pirata criado em (X, Y) - INVISÍVEL
🏴‍☠️ Navio Pirata Tipo 1 criado em (X, Y)
   HP: 60 | Velocidade: 2.0 (RÁPIDO)
🏴‍☠️ Navio Pirata Tipo 1 vinculado a 4 pilares
```

### **Se Não Aparecer**:
- ❌ Verifique se os parents estão definidos
- ❌ Verifique se há pilares no mapa
- ❌ Pressione F7 para recarregar os scripts

---

## 🎮 Teste Prático

### **Teste 1: Visibilidade**
1. Posicione um `obj_navio_pirata` no mapa
2. Execute o jogo
3. ✓ O navio deve aparecer no mapa

### **Teste 2: Patrulha**
1. Coloque 4 `obj_pilar_pirata` formando um quadrado
2. Coloque um `obj_navio_pirata` no centro
3. Execute o jogo
4. ✓ O navio deve navegar entre os pilares em loop

### **Teste 3: Combate**
1. Coloque um `obj_navio_pirata` e um `obj_navio_transporte` próximos
2. Execute o jogo
3. ✓ O navio pirata deve atacar o transporte

### **Teste 4: Carga**
1. Coloque um `obj_navio_carga` no mapa
2. Execute o jogo
3. ✓ O navio de carga deve aparecer (frágil e lento)

---

## 🐛 Troubleshooting

### **Problema: Navio não aparece**
**Solução**:
- [ ] Verifique se o parent está definido em `obj_navio_base`
- [ ] Verifique se o navio está em água (terreno correto)
- [ ] Verifique o console por mensagens de erro

### **Problema: Navio aparece mas não se move**
**Solução**:
- [ ] Verifique se há pilares em até 1000px
- [ ] Verifique se `estado = LanchaState.PATRULHANDO` no console
- [ ] Verifique se `vinculado = true` após vinculação

### **Problema: Navio não ataca**
**Solução**:
- [ ] Verifique se o alvo é de nação diferente (1, 2)
- [ ] Verifique se o alvo está dentro do raio de detecção
- [ ] Verifique se o navio tem munição (reload_timer)

### **Problema: Muitos erros no console**
**Solução**:
- [ ] Recompile o projeto (F7)
- [ ] Verifique os parents novamente
- [ ] Verifique se `obj_navio_base` existe

---

## 📊 Atributos Confirmados

### **Navio Pirata Tipo 1**
```gml
HP: 60
Velocidade: 2.0
Dano: 12
Detecção: 500px
Especialidade: Rápido e ágil
```

### **Navio Pirata Tipo 2**
```gml
HP: 80
Velocidade: 1.6
Dano: 15
Detecção: 400px
Especialidade: Balanceado
```

### **Navio Pirata Tipo 3**
```gml
HP: 120
Velocidade: 1.2
Dano: 20
Detecção: 350px
Especialidade: Forte mas lento
```

### **Navio de Carga**
```gml
HP: 40 (MUITO FRÁGIL)
Velocidade: 0.8 (MUITO LENTO)
Dano: 0 (NUNCA ATACA)
Valor: 5000
```

---

## 🎯 Próximas Ações

1. **Configure os parents** nos objetos (CRÍTICO!)
2. **Teste no jogo** (F5)
3. **Posicione pilares** e navios no mapa
4. **Execute e observar** o comportamento
5. **Reporte qualquer erro** no console

---

## ✨ Se Tudo Estiver Funcionando

Você verá:
- ✅ Navios piratas patrulhando automaticamente
- ✅ Pilares invisíveis formando rotas
- ✅ Piratas atacando navios inimigos
- ✅ Barras de vida quando atingidos
- ✅ Sistema de carga funcionando

**Pronto para usar em seu jogo!** 🚀

---

## 📝 Checklist Final

- [ ] Parents definidos para todos os 4 objetos
- [ ] Pilares posicionados no mapa
- [ ] Navios piratas criados
- [ ] Navio de carga adicionado
- [ ] Console mostra mensagens esperadas
- [ ] Navios aparecem no mapa
- [ ] Navios se movem
- [ ] Navios atacam
- [ ] Sistema funcionando! ✓


