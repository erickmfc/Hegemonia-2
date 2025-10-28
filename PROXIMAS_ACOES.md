# 🎯 Próximas Ações — Navio Transporte

**Prioridade:** 🔴 ALTA  
**Data:** 26 de Outubro de 2025

---

## 📌 Ações Imediatas (CRÍTICAS)

### 1️⃣ Teste de Compilação Completo
**Status:** ⏳ PENDENTE  
**Ação:**
- [ ] Executar build completo
- [ ] Verificar erros de compilação
- [ ] Verificar avisos (warnings)
- [ ] Confirmar sem erros de runtime

**Resultado esperado:** Sem erros

---

### 2️⃣ Teste de Funcionalidade Básica
**Status:** ⏳ PENDENTE  
**Ações:**

#### Navio Transporte
- [ ] Criar navio no menu
- [ ] Testar comando P (embarque/desembarque)
- [ ] Testar comando L (parar)
- [ ] Testar comando K (patrulha)
- [ ] Testar comando O (ataque/passivo)
- [ ] Testar comando J (menu de carga)
- [ ] Testar movimento em água
- [ ] Testar detecção de unidades para embarque
- [ ] Testar desembarque automático

#### Ronald Reagan
- [ ] Testar herança de navio_transporte
- [ ] Testar todos os comandos
- [ ] Confirmar capacidades corretas (35 aviões, 20 veículos, 100 soldados)

**Resultado esperado:** Todos os comandos funcionando

---

### 3️⃣ Testes de Erro
**Status:** ✅ CONCLUÍDO (Fase anterior)  
**Erros que devem estar corrigidos:**
- ✅ `obj_submarino` não definido
- ✅ `modo_combate` não definido
- ✅ `estado` não definido
- ✅ `estado_embarque` não definido
- ✅ `selecionado` não definido

---

## 📋 Ações Secundárias (IMPORTANTES)

### 4️⃣ Otimização de Performance
**Status:** ⏳ PENDENTE  
**Verificações:**
- [ ] FPS durante embarque de múltiplas unidades
- [ ] FPS durante patrulha com muitos pontos
- [ ] FPS durante movimento em água
- [ ] Loops com `with` statements otimizados
- [ ] Cálculos de distância reduzidos se necessário

**Objetivo:** Manter FPS > 60

---

### 5️⃣ Refinamento Visual
**Status:** ⏳ PENDENTE  
**Melhorias:**
- [ ] Feedback visual em terra (vermelho indicando impossível)
- [ ] Animação de embarque/desembarque
- [ ] Efeitos de som (se houver sistema)
- [ ] Ícones no menu de carga
- [ ] Indicador de capacidade mais visual

---

### 6️⃣ Balanceamento de Jogo
**Status:** ⏳ PENDENTE  
**Ajustes:**
- [ ] Custo do navio (2000 dinheiro, 30 população)
- [ ] Tempo de produção (300 frames = 5 segundos)
- [ ] Velocidade de movimento (velocidade_movimento = 4)
- [ ] Raio de embarque (raio_embarque = 80)
- [ ] Intervalo de desembarque (desembarque_intervalo = 120 frames)
- [ ] Capacidades (10 aviões, 10 veículos, 50 soldados)

**Objetivo:** Balanceamento adequado

---

## 🔍 Ações de Validação

### 7️⃣ Verificação de Integridade
**Status:** ⏳ PENDENTE  
**Checklist:**
- [ ] Todos os enums existem
- [ ] Todas as funções estão definidas
- [ ] Não há referencias quebradas
- [ ] Variáveis inicializadas corretamente
- [ ] Sem variáveis globais não declaradas

---

### 8️⃣ Documentação Final
**Status:** ⏳ PENDENTE  
**Tarefas:**
- [ ] Comentários adicionados a funções-chave
- [ ] README atualizado
- [ ] Guia de uso criado
- [ ] Problemas conhecidos listados

---

## 🚀 Ações de Deploy

### 9️⃣ Preparação para Release
**Status:** ⏳ PENDENTE  
**Checklist:**
- [ ] Código limpo e formatado
- [ ] Debug messages revisadas
- [ ] Sem linhas comentadas desnecessárias
- [ ] Sem arquivos temporários
- [ ] Sem TODOs pendentes no código

---

## 📊 Checklist de Verificação Final

| Item | Status | Prioridade |
|------|--------|-----------|
| Compilação | ⏳ | 🔴 ALTA |
| Testes Básicos | ⏳ | 🔴 ALTA |
| Performance | ⏳ | 🟠 MÉDIA |
| Visual/UX | ⏳ | 🟡 BAIXA |
| Balanceamento | ⏳ | 🟠 MÉDIA |
| Documentação | ⏳ | 🟡 BAIXA |

---

## 📝 Notas Importantes

### Herança
```
obj_navio_base
    ↓
obj_navio_transporte (Step_0 tem event_inherited() no INÍCIO)
    ↓
obj_RonaldReagan (herda de navio_transporte)
```

⚠️ **CRÍTICO:** `event_inherited()` deve estar NO INÍCIO de Step_0.gml para garantir que variáveis herdadas existem

### Variáveis Verificadas
Todas as variáveis customizadas agora são verificadas com:
```gml
if (variable_instance_exists(id, "nome_variavel") && nome_variavel == valor)
```

### Enum NavioTransporteEstado
```gml
enum NavioTransporteEstado {
    PARADO,           // Navio parado
    NAVEGANDO,        // Navio se movendo
    PATRULHANDO,      // Navio patrulhando
    EMBARQUE_ATIVO,   // 🚚 Recebendo unidades
    EMBARQUE_OFF,     // ✅ Cheio ou desativado
    DESEMBARCANDO,    // 📦 Liberando unidades
    ATACANDO          // ⚔️ Ataque (delegado ao pai)
}
```

---

## 🎯 Ordem de Execução Recomendada

1. **Teste de Compilação** ← COMECE AQUI
2. **Testes Básicos**
3. **Testes de Erro**
4. **Performance**
5. **Visual/UX**
6. **Balanceamento**
7. **Documentação**
8. **Deploy**

---

## ⏰ Timeline Estimada

| Ação | Tempo Estimado |
|------|---|
| Compilação | 5 min |
| Testes Básicos | 15 min |
| Otimização | 20 min |
| Refinamento Visual | 30 min |
| Balanceamento | 15 min |
| Documentação | 10 min |
| **Total** | **1h 35 min** |

---

## 🆘 Troubleshooting

Se encontrar erros durante testes:

### Erro: "Variable X not set before reading it"
**Solução:** Adicione verificação `variable_instance_exists(id, "X")`

### Erro: "obj_X does not exist"
**Solução:** Verifique se o objeto existe com `object_exists()`

### Erro: "Function X not defined"
**Solução:** Confirme que a função está no Create_0.gml ou no script

### Performance baixa
**Solução:** 
1. Reduza número de unidades embarquadas
2. Otimize loops com `with`
3. Reduza raio de detecção
4. Use menos effects visuais

---

## ✅ Conclusão

O Navio Transporte está **95% implementado**. Apenas testes e pequenos ajustes finais permanecem.

**Próximo passo:** Executar compilação completa e testes básicos.

---

**Responsável:** AI Assistant  
**Última atualização:** 26 de Outubro de 2025
