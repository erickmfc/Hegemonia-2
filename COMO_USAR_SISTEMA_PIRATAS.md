# 🏴‍☠️ COMO USAR O SISTEMA DE PIRATAS

## Passo a Passo para Implementação

### **PASSO 1: Adicionar Pilares no Mapa**

1. Abra sua room/sala no GameMaker
2. Na aba "Creation" ou "Room Editor"
3. Procure por `obj_pilar_pirata` na lista de objetos
4. Arraste e solte múltiplas instâncias para formar uma rota circular

**Exemplo de Rota (formato visual)**:
```
    Pilar 1
       ↓
Pilar 4 → Pilar 2
       ↑
    Pilar 3
```

**Dica**: Coloque os pilares a aproximadamente 300-400px de distância um do outro

---

### **PASSO 2: Adicionar Navios Piratas**

1. Procure por `obj_navio_pirata`, `obj_navio_pirata2` ou `obj_navio_pirata3`
2. Arraste para o mapa onde deseja que os piratas apareçam
3. Você pode misturar os 3 tipos na mesma rota

**Exemplo**:
- 2x `obj_navio_pirata` (rápidos)
- 1x `obj_navio_pirata2` (balanceado)
- 1x `obj_navio_pirata3` (resistente)

---

### **PASSO 3: Testar**

1. Pressione Play (F5)
2. Observe os navios piratas:
   - Procurando pelos pilares automaticamente
   - Patrulhando a rota
   - Atacando seus navios se entrar em contato

---

## 📍 Exemplo Prático

### **Cenário 1: Rota em Linha**
```gml
// Coloque os pilares em linha reta:
Pilar_1 (100, 100)
Pilar_2 (300, 100)
Pilar_3 (500, 100)
Pilar_4 (300, 200)  // Volta ao início
```

### **Cenário 2: Rota em Círculo**
```gml
// Coloque pilares formando um círculo:
Pilar_1 (500, 100)   // Topo
Pilar_2 (700, 300)   // Direita
Pilar_3 (500, 500)   // Fundo
Pilar_4 (300, 300)   // Esquerda
```

### **Cenário 3: Rota Complexa**
```gml
// Múltiplos pilares em rota complexa:
Pilar_1 (200, 150)
Pilar_2 (400, 100)
Pilar_3 (600, 150)
Pilar_4 (700, 350)
Pilar_5 (600, 550)
Pilar_6 (300, 550)
Pilar_7 (100, 350)
Pilar_8 (50, 200)
```

---

## 🎮 Comportamento Esperado

### **Tipo 1 (Rápido) - `obj_navio_pirata`**
- ⚡ Rápido e ágil
- ☠️ Ataca navios de carga com força
- 💪 Fraco contra navios militares
- 🏃 Patrulha rápida

### **Tipo 2 (Balanceado) - `obj_navio_pirata2`**
- ⚖️ Equilibrado
- ☠️ Bom contra carga
- 💪 Moderadamente fraco contra militares
- 🚶 Patrulha normal

### **Tipo 3 (Resistente) - `obj_navio_pirata3`**
- 🛡️ Muito resistente
- ☠️ Muito forte contra carga
- 💪 Menos fraco contra militares
- 🐢 Patrulha lenta mas persistente

---

## 🔍 Verificação de Funcionamento

### **Checklist**
- [ ] Pilares foram colocados no mapa
- [ ] Pelo menos um navio pirata foi colocado
- [ ] Você vê mensagens de debug:
  - "🏴‍☠️ Pilar Pirata criado..."
  - "🏴‍☠️ Navio Pirata Tipo X criado..."
  - "🏴‍☠️ ... vinculado a X pilares"
- [ ] Navios começam a se mover após 1-2 segundos
- [ ] Navios param nos pilares brevemente
- [ ] Se houver navios inimigos próximos, piratas os atacam

---

## ⚠️ Troubleshooting

### **Navio Pirata Não Aparece**
- Verifique se o objeto existe no room
- Verifique o console por mensagens de erro

### **Navio Não Se Vincula aos Pilares**
- Certifique-se de que há pilares em até 1000px de distância
- Verifique a mensagem de debug: "ERRO: Nenhum pilar encontrado"

### **Navio Não Ataca**
- Verifique se o navio inimigo é de nação diferente de 3
- Verifique a distância (deve estar dentro do raio de detecção)

### **Navio Ataca Muito Lento/Rápido**
- Tipo 1: Recarga 1.25s (mais rápido)
- Tipo 2: Recarga 1.5s
- Tipo 3: Recarga 2.0s (mais lento)

---

## 📊 Performance

- **Pilares**: Mínimo impacto (invisíveis, sem colisão)
- **Navios**: Normal (mesmo que outras unidades)
- **Limite**: Pode ter até ~20 navios piratas simultâneos sem problemas

---

## 🎯 Dicas Avançadas

### **1. Diferentes Rotas**
Crie múltiplas áreas com pilares para ter diferentes rotas piratas:
```
Área 1: Rota Costeira (4 pilares)
Área 2: Rota Central (6 pilares)
Área 3: Rota Interna (3 pilares)
```

### **2. Ajustar Dificuldade**
- Mais Tipo 3 (resistente) = Mais difícil
- Mais Tipo 1 (rápido) = Mais ágil
- Mix = Balanceado

### **3. Combinar com IA Aliada**
Posicione suas unidades militares para defender rotas

---

## 🎬 Resultado Final

Ao seguir estes passos, você terá:
✅ Navios piratas patrulhando automaticamente
✅ Sistema de ataque funcional
✅ Comportamentos diferenciados por tipo
✅ Sem necessidade de modificações adicionais

Pronto para jogar! 🚀

