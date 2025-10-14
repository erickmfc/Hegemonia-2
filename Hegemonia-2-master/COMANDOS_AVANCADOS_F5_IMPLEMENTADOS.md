# COMANDOS AVANÇADOS F-5 - IMPLEMENTAÇÃO COMPLETA

## 🎯 **SISTEMA IMPLEMENTADO**

### **Funcionalidades Avançadas:**
- ✅ **Seguir com alvo definido pelo jogador**
- ✅ **Patrulha com waypoints customizados**
- ✅ **Feedback visual completo**
- ✅ **Comando de avançar para próximo ponto**

---

## 🎮 **CONTROLES AVANÇADOS**

### **1. COMANDO SEGUIR (Tecla 'E')**
```
1. Selecione o F-5 (clique esquerdo)
2. Pressione 'E' para entrar no modo seguir
3. Clique em qualquer unidade para o F-5 seguir
4. O F-5 seguirá a unidade até ela ser destruída ou você cancelar
```

**Feedback Visual:**
- Mensagem: "🎯 Modo SEGUIR: Clique em uma unidade para seguir"
- Status na tela: "CLIQUE EM UMA UNIDADE PARA SEGUIR" (laranja)

### **2. COMANDO PATRULHA (Tecla 'Q')**
```
1. Selecione o F-5 (clique esquerdo)
2. Pressione 'Q' para entrar no modo de definição de patrulha
3. Clique em vários pontos para criar a rota
4. Pressione 'Q' novamente para iniciar a patrulha
5. O F-5 seguirá a rota em loop infinito
```

**Feedback Visual:**
- Linhas azuis conectando os pontos
- Círculos azuis nos waypoints
- Círculo amarelo no ponto atual
- Linha verde do último ponto até o mouse (modo definição)
- Status na tela: "CLIQUE PARA ADICIONAR PONTOS | Q = INICIAR" (verde)

### **3. COMANDO AVANÇAR PONTO (Tecla 'N')**
```
1. Durante a patrulha, pressione 'N' para avançar para o próximo ponto
2. Útil para acelerar a patrulha ou pular pontos
```

**Feedback Visual:**
- Círculo amarelo se move para o próximo ponto
- Mensagem: "⏭️ Avançando para próximo ponto de patrulha"

---

## 🔧 **ARQUIVOS MODIFICADOS**

### **1. obj_controlador_unidades/Create_0.gml**
```gml
// Variáveis globais para comandos avançados
global.esperando_alvo_seguir = noone;
global.definindo_patrulha = noone;
```

### **2. obj_controlador_unidades/Step_0.gml**
- Lógica de seleção de alvo para comando Seguir
- Lógica de adição de pontos de patrulha
- Cancelamento de comandos ao clicar no vazio

### **3. obj_controlador_unidades/Step_1.gml**
- Comando 'E' para modo Seguir
- Comando 'Q' para modo Patrulha
- Gerenciamento de estados globais

### **4. obj_caca_f5/Create_0.gml**
```gml
// Sistema de patrulha avançado
pontos_patrulha = ds_list_create();
indice_patrulha_atual = 0;
```

### **5. obj_caca_f5/Step_0.gml**
- Lógica de patrulha com waypoints
- Comando 'N' para avançar ponto
- Remoção de comandos antigos (Q e E locais)

### **6. obj_caca_f5/Draw_0.gml**
- Feedback visual completo das rotas
- Instruções de controle atualizadas
- Status dos comandos avançados

---

## 🎯 **COMO USAR**

### **Cenário 1: Seguir uma Unidade Específica**
```
1. Produza um F-5 no Aeroporto Militar
2. Selecione o F-5
3. Pressione 'E'
4. Clique em um tanque inimigo
5. O F-5 seguirá o tanque automaticamente
```

### **Cenário 2: Patrulha Customizada**
```
1. Selecione o F-5
2. Pressione 'Q'
3. Clique em 4 pontos formando um quadrado
4. Pressione 'Q' novamente
5. O F-5 patrulhará o quadrado em loop
6. Use 'N' para acelerar a patrulha
```

### **Cenário 3: Combinação de Comandos**
```
1. Configure uma patrulha triangular
2. Durante a patrulha, pressione 'E'
3. Clique em um inimigo para seguir
4. O F-5 abandona a patrulha e segue o inimigo
5. Quando o inimigo morrer, volte para patrulha
```

---

## 🔍 **DETALHES TÉCNICOS**

### **Sistema de Estados:**
- `ESTADO_F5.SEGUINDO` - Segue alvo específico
- `ESTADO_F5.PATRULHA` - Patrulha waypoints customizados
- `ESTADO_F5.MOVENDO` - Movimento livre

### **Variáveis Globais:**
- `global.esperando_alvo_seguir` - F-5 aguardando seleção de alvo
- `global.definindo_patrulha` - F-5 em modo de definição de rota

### **Estrutura de Dados:**
- `pontos_patrulha` - DS List com coordenadas [x, y]
- `indice_patrulha_atual` - Ponto atual da patrulha
- `alvo_seguir` - Unidade a ser seguida

---

## 🎨 **FEEDBACK VISUAL**

### **Cores e Significados:**
- **Azul (c_aqua)**: Linhas e pontos de patrulha
- **Amarelo (c_yellow)**: Ponto atual da patrulha
- **Verde (c_lime)**: Linha de definição de rota
- **Laranja (c_orange)**: Status de modo Seguir
- **Verde (c_lime)**: Status de modo Patrulha

### **Elementos Visuais:**
- Linhas conectando waypoints
- Círculos nos pontos de patrulha
- Destaque do ponto atual
- Linha de preview durante definição
- Instruções contextuais na tela

---

## ✅ **TESTE DO SISTEMA**

### **Checklist de Testes:**
1. [ ] F-5 pode ser selecionado normalmente
2. [ ] Comando 'E' ativa modo Seguir
3. [ ] Clique em unidade define alvo para seguir
4. [ ] Comando 'Q' ativa modo Patrulha
5. [ ] Cliques adicionam pontos de patrulha
6. [ ] Segundo 'Q' inicia patrulha
7. [ ] Comando 'N' avança para próximo ponto
8. [ ] Feedback visual funciona corretamente
9. [ ] Instruções aparecem na tela
10. [ ] Sistema funciona com zoom e câmera

---

## 🚀 **PRÓXIMOS PASSOS**

### **Melhorias Futuras:**
- [ ] Patrulha em forma de triângulo automática
- [ ] Comando de cancelar patrulha
- [ ] Salvamento de rotas de patrulha
- [ ] Patrulha para múltiplas unidades
- [ ] Comando de retorno ao aeroporto

---

**Data:** 2025-01-27  
**Status:** ✅ **IMPLEMENTAÇÃO COMPLETA**  
**Sistema:** Comandos Avançados F-5  
**Funcionalidade:** Seguir + Patrulha com Waypoints
