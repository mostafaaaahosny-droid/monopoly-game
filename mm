<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
<title>🎩 مونوبولي المصغر</title>
<style>
  * { margin:0; padding:0; box-sizing:border-box; -webkit-tap-highlight-color:transparent; }
  body {
    font-family: 'Segoe UI', Tahoma, sans-serif;
    background: linear-gradient(135deg, #1a1a2e, #16213e);
    color: #fff; min-height:100vh; overflow-x:hidden;
    user-select:none;
  }
  .app { max-width:520px; margin:0 auto; padding:10px; }

  /* الهيدر */
  .header {
    display:flex; justify-content:space-between; align-items:center;
    background: rgba(255,255,255,0.08); border-radius:14px;
    padding:10px 14px; margin-bottom:10px;
    backdrop-filter: blur(10px);
    border:1px solid rgba(255,255,255,0.1);
  }
  .player-info { display:flex; flex-direction:column; gap:2px; }
  .player-info .name { font-size:13px; opacity:0.8; }
  .player-info .money { font-size:18px; font-weight:bold; color:#4ade80; }
  .player-info.ai .money { color:#f87171; }
  .avatar { font-size:22px; }

  /* اللوحة */
  .board {
    display:grid;
    grid-template-columns: repeat(5, 1fr);
    gap:4px; margin-bottom:10px;
    background: rgba(0,0,0,0.3);
    padding:6px; border-radius:16px;
  }
  .cell {
    aspect-ratio: 1/1;
    background: linear-gradient(145deg, #2a2a40, #1e1e30);
    border-radius:8px;
    display:flex; flex-direction:column;
    align-items:center; justify-content:center;
    font-size:9px; text-align:center; padding:2px;
    position:relative; overflow:hidden;
    border:1px solid rgba(255,255,255,0.06);
    transition: all 0.3s;
  }
  .cell .emoji { font-size:18px; line-height:1; }
  .cell .price { font-size:8px; color:#fbbf24; font-weight:bold; }
  .cell.owned-me { background: linear-gradient(145deg,#166534,#14532d); border-color:#4ade80; }
  .cell.owned-ai { background: linear-gradient(145deg,#7f1d1d,#450a0a); border-color:#f87171; }
  .cell .owner-dot {
    position:absolute; top:2px; right:2px;
    width:8px; height:8px; border-radius:50%;
  }
  .owner-me { background:#4ade80; }
  .owner-ai { background:#f87171; }

  /* التوكنز */
  .token {
    position:absolute; font-size:14px;
    transition: all 0.35s ease;
    filter: drop-shadow(0 0 4px rgba(255,255,255,0.6));
    z-index:5;
  }
  .token.me { bottom:2px; left:2px; }
  .token.ai { bottom:2px; right:2px; }

  /* منطقة التحكم */
  .controls {
    background: rgba(255,255,255,0.08); border-radius:14px;
    padding:12px; backdrop-filter: blur(10px);
    border:1px solid rgba(255,255,255,0.1);
  }
  .status {
    text-align:center; font-size:13px; margin-bottom:10px;
    min-height:20px; color:#fbbf24; font-weight:600;
  }
  .dice-area {
    display:flex; align-items:center; justify-content:center;
    gap:15px; margin-bottom:12px;
  }
  .dice {
    width:60px; height:60px;
    background: linear-gradient(145deg,#fff,#e0e0e0);
    border-radius:12px; display:flex;
    align-items:center; justify-content:center;
    font-size:32px; color:#1a1a2e;
    box-shadow: 0 4px 15px rgba(0,0,0,0.4);
  }
  .dice.rolling { animation: roll 0.5s ease; }
  @keyframes roll {
    0%,100% { transform: rotate(0) scale(1); }
    25% { transform: rotate(-20deg) scale(1.1); }
    50% { transform: rotate(20deg) scale(0.95); }
    75% { transform: rotate(-10deg) scale(1.05); }
  }

  .btn {
    flex:1; padding:14px; border:none; border-radius:12px;
    font-size:15px; font-weight:bold; cursor:pointer;
    transition: all 0.2s; font-family:inherit;
    color:#fff;
  }
  .btn:active { transform: scale(0.96); }
  .btn:disabled { opacity:0.4; cursor:not-allowed; }
  .btn-primary { background: linear-gradient(135deg,#3b82f6,#2563eb); box-shadow:0 4px 12px rgba(59,130,246,0.4); }
  .btn-success { background: linear-gradient(135deg,#22c55e,#16a34a); box-shadow:0 4px 12px rgba(34,197,94,0.4); }
  .btn-danger { background: linear-gradient(135deg,#ef4444,#dc2626); box-shadow:0 4px 12px rgba(239,68,68,0.4); }
  .btn-warning { background: linear-gradient(135deg,#f59e0b,#d97706); box-shadow:0 4px 12px rgba(245,158,11,0.4); }

  .action-row { display:flex; gap:8px; margin-top:8px; }

  /* نافذة منبثقة */
  .modal {
    position:fixed; inset:0; background: rgba(0,0,0,0.7);
    display:none; align-items:center; justify-content:center;
    padding:20px; z-index:100;
    backdrop-filter: blur(6px);
  }
  .modal.show { display:flex; }
  .modal-box {
    background: linear-gradient(145deg,#1e1e30,#2a2a40);
    border-radius:20px; padding:24px; max-width:340px; width:100%;
    text-align:center; border:1px solid rgba(255,255,255,0.1);
    animation: pop 0.3s ease;
  }
  @keyframes pop {
    from { transform: scale(0.8); opacity:0; }
    to { transform: scale(1); opacity:1; }
  }
  .modal-box h2 { margin-bottom:12px; font-size:20px; }
  .modal-box p { margin-bottom:16px; opacity:0.85; font-size:14px; }
  .modal-emoji { font-size:48px; margin-bottom:10px; }
</style>
</head>
<body>
<div class="app">

  <!-- الهيدر -->
  <div class="header">
    <div class="player-info">
      <span class="name">👤 أنت</span>
      <span class="money" id="myMoney">$1000</span>
    </div>
    <div class="avatar">🎩</div>
    <div class="player-info ai" style="text-align:left">
      <span class="name">🤖 خصم</span>
      <span class="money" id="aiMoney">$1000</span>
    </div>
  </div>

  <!-- اللوحة -->
  <div class="board" id="board"></div>

  <!-- التحكم -->
  <div class="controls">
    <div class="status" id="status">اضغط "ارمِ النرد" للبدء 🎲</div>
    <div class="dice-area">
      <div class="dice" id="dice">🎲</div>
    </div>
    <div class="action-row">
      <button class="btn btn-primary" id="rollBtn">🎲 ارمِ النرد</button>
    </div>
    <div class="action-row" id="buyRow" style="display:none">
      <button class="btn btn-success" id="buyBtn">💰 اشترِ</button>
      <button class="btn btn-danger" id="skipBtn">❌ تخطَّ</button>
    </div>
  </div>

</div>

<!-- نافذة -->
<div class="modal" id="modal">
  <div class="modal-box">
    <div class="modal-emoji" id="modalEmoji">🎉</div>
    <h2 id="modalTitle">عنوان</h2>
    <p id="modalText">نص</p>
    <button class="btn btn-primary" id="modalBtn">حسناً</button>
  </div>
</div>

<script>
// ============ الأصوات (Web Audio API) ============
let audioCtx;
function initAudio() {
  if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
}
function playTone(freq, duration=0.15, type='sine', vol=0.15) {
  initAudio();
  const osc = audioCtx.createOscillator();
  const gain = audioCtx.createGain();
  osc.type = type;
  osc.frequency.setValueAtTime(freq, audioCtx.currentTime);
  gain.gain.setValueAtTime(vol, audioCtx.currentTime);
  gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + duration);
  osc.connect(gain); gain.connect(audioCtx.destination);
  osc.start(); osc.stop(audioCtx.currentTime + duration);
}
const SFX = {
  dice: () => { playTone(300,0.06,'square',0.1); setTimeout(()=>playTone(400,0.06,'square',0.1),70); setTimeout(()=>playTone(500,0.08,'square',0.1),140); },
  move: () => playTone(600,0.08,'sine',0.08),
  buy: () => { playTone(523,0.1,'sine',0.15); setTimeout(()=>playTone(659,0.1,'sine',0.15),100); setTimeout(()=>playTone(784,0.15,'sine',0.15),200); },
  rent: () => { playTone(400,0.15,'sawtooth',0.12); setTimeout(()=>playTone(300,0.2,'sawtooth',0.12),150); },
  win: () => { [523,659,784,1047].forEach((f,i)=>setTimeout(()=>playTone(f,0.15,'sine',0.15),i*120)); },
  lose: () => { [400,300,200].forEach((f,i)=>setTimeout(()=>playTone(f,0.2,'sawtooth',0.12),i*150)); },
  click: () => playTone(700,0.05,'sine',0.1),
  pass: () => playTone(350,0.1,'sine',0.08)
};

// ============ بيانات اللوحة ============
const BOARD = [
  { name:"ابدأ", emoji:"🚩", type:"start" },
  { name:"بيت", emoji:"🏠", type:"property", price:100, rent:20 },
  { name:"مقهى", emoji:"☕", type:"property", price:120, rent:25 },
  { name:"حظ", emoji:"❓", type:"chance" },
  { name:"سيارة", emoji:"🚗", type:"property", price:150, rent:30 },
  { name:"سوق", emoji:"🏪", type:"property", price:180, rent:35 },
  { name:"سجن", emoji:"🚔", type:"jail" },
  { name:"فندق", emoji:"🏨", type:"property", price:200, rent:40 },
  { name:"حظ", emoji:"❓", type:"chance" },
  { name:"ملاهي", emoji:"🎡", type:"property", price:220, rent:45 },
  { name:"بنك", emoji:"🏦", type:"bank" },
  { name:"مطار", emoji:"✈️", type:"property", price:250, rent:50 },
  { name:"حديقة", emoji:"🌳", type:"property", price:150, rent:30 },
  { name:"حظ", emoji:"❓", type:"chance" },
  { name:"ملهى", emoji:"🎭", type:"property", price:180, rent:35 },
  { name:"قلعة", emoji:"🏰", type:"property", price:300, rent:60 }
];

// ============ حالة اللعبة ============
const state = {
  myMoney: 1000,
  aiMoney: 1000,
  myPos: 0,
  aiPos: 0,
  owners: {}, // index -> 'me' | 'ai'
  turn: 'me',
  phase: 'idle', // idle | rolling | buying | ai
  canBuy: false
};

// ============ DOM ============
const boardEl = document.getElementById('board');
const statusEl = document.getElementById('status');
const diceEl = document.getElementById('dice');
const rollBtn = document.getElementById('rollBtn');
const buyRow = document.getElementById('buyRow');
const buyBtn = document.getElementById('buyBtn');
const skipBtn = document.getElementById('skipBtn');
const myMoneyEl = document.getElementById('myMoney');
const aiMoneyEl = document.getElementById('aiMoney');
const modal = document.getElementById('modal');
const modalTitle = document.getElementById('modalTitle');
const modalText = document.getElementById('modalText');
const modalEmoji = document.getElementById('modalEmoji');
const modalBtn = document.getElementById('modalBtn');

// ============ رسم اللوحة ============
function renderBoard() {
  boardEl.innerHTML = '';
  BOARD.forEach((cell, i) => {
    const div = document.createElement('div');
    div.className = 'cell';
    div.id = 'cell-' + i;

    if (state.owners[i] === 'me') div.classList.add('owned-me');
    if (state.owners[i] === 'ai') div.classList.add('owned-ai');

    let inner = `<div class="emoji">${cell.emoji}</div><div>${cell.name}</div>`;
    if (cell.price) inner += `<div class="price">$${cell.price}</div>`;
    div.innerHTML = inner;

    if (state.owners[i]) {
      const dot = document.createElement('div');
      dot.className = 'owner-dot ' + (state.owners[i]==='me'?'owner-me':'owner-ai');
      div.appendChild(dot);
    }

    // التوكنز
    if (state.myPos === i) {
      const t = document.createElement('div');
      t.className = 'token me'; t.textContent = '👤';
      div.appendChild(t);
    }
    if (state.aiPos === i) {
      const t = document.createElement('div');
      t.className = 'token ai'; t.textContent = '🤖';
      div.appendChild(t);
    }

    boardEl.appendChild(div);
  });
}

// ============ تحديث واجهة ============
function updateUI() {
  myMoneyEl.textContent = '$' + state.myMoney;
  aiMoneyEl.textContent = '$' + state.aiMoney;
  renderBoard();
}

// ============ نافذة ============
function showModal(title, text, emoji='🎉', callback) {
  modalTitle.textContent = title;
  modalText.textContent = text;
  modalEmoji.textContent = emoji;
  modal.classList.add('show');
  modalBtn.onclick = () => {
    SFX.click();
    modal.classList.remove('show');
    if (callback) callback();
  };
}

// ============ حركة ============
function movePlayer(who, steps) {
  return new Promise(resolve => {
    let count = 0;
    const interval = setInterval(() => {
      if (who === 'me') {
        state.myPos = (state.myPos + 1) % BOARD.length;
      } else {
        state.aiPos = (state.aiPos + 1) % BOARD.length;
      }
      SFX.move();
      renderBoard();
      count++;
      if (count >= steps) {
        clearInterval(interval);
        setTimeout(resolve, 300);
      }
    }, 280);
  });
}

// ============ منطق الخلية ============
async function landOn(who) {
  const pos = who === 'me' ? state.myPos : state.aiPos;
  const cell = BOARD[pos];
  const isMe = who === 'me';
  const moneyKey = isMe ? 'myMoney' : 'aiMoney';

  // خصم/إضافة
  const changeMoney = (amount) => {
    state[moneyKey] += amount;
    updateUI();
  };

  if (cell.type === 'start') {
    changeMoney(200);
    if (isMe) SFX.buy();
    showModal('🚩 ابدأ', (isMe?'ربحت':'الخصم ربح') + ' $200!', '🎁');
    return;
  }

  if (cell.type === 'jail') {
    changeMoney(-100);
    if (isMe) SFX.rent();
    showModal('🚔 سجن', (isMe?'دفعت':'الخصم دفع') + ' $100 غرامة', '😅');
    return;
  }

  if (cell.type === 'bank') {
    changeMoney(150);
    if (isMe) SFX.buy();
    showModal('🏦 بنك', (isMe?'ربحت':'الخصم ربح') + ' $150 من البنك!', '💰');
    return;
  }

  if (cell.type === 'chance') {
    const events = [
      { txt:'ربحت $100!', amt:100, emoji:'🎁' },
      { txt:'دفعت $80 غرامة!', amt:-80, emoji:'💸' },
      { txt:'ربحت $50!', amt:50, emoji:'💵' },
      { txt:'خسرت $120!', amt:-120, emoji:'😢' },
      { txt:'ربحت $200!', amt:200, emoji:'🤑' }
    ];
    const ev = events[Math.floor(Math.random()*events.length)];
    changeMoney(ev.amt);
    if (ev.amt > 0) SFX.buy(); else SFX.rent();
    showModal('❓ حظ', (isMe?'أنت: ':'الخصم: ') + ev.txt, ev.emoji);
    return;
  }

  if (cell.type === 'property') {
    const owner = state.owners[pos];
    if (!owner) {
      if (isMe) {
        // خيار الشراء
        state.canBuy = true;
        state.phase = 'buying';
        statusEl.textContent = `هل تريد شراء ${cell.name} بـ $${cell.price}؟`;
        buyRow.style.display = 'flex';
        rollBtn.disabled = true;
        return;
      } else {
        // AI يشتري إذا عنده فلوس
        if (state.aiMoney >= cell.price) {
          state.owners[pos] = 'ai';
          state.aiMoney -= cell.price;
          updateUI();
          SFX.buy();
          showModal('🤖 الخصم اشترى!', `اشترى ${cell.name} بـ $${cell.price}`, '😱');
        }
      }
    } else if (owner !== who) {
      // دفع إيجار
      changeMoney(-cell.rent);
      if (isMe) SFX.rent(); else SFX.buy();
      showModal('💸 إيجار', `دفعت $${cell.rent} إيجار لـ ${cell.name}`, '😤');
    }
  }
}

// ============ رمي النرد ============
async function rollDice() {
  if (state.phase === 'rolling' || state.phase === 'buying') return;
  state.phase = 'rolling';
  rollBtn.disabled = true;

  diceEl.classList.add('rolling');
  SFX.dice();

  // اهتزاز الأرقام
  let shakeCount = 0;
  const shakeInt = setInterval(() => {
    diceEl.textContent = ['⚀','⚁','⚂','⚃','⚄','⚅'][Math.floor(Math.random()*6)];
    shakeCount++;
    if (shakeCount > 8) clearInterval(shakeInt);
  }, 60);

  const result = Math.floor(Math.random() * 6) + 1;

  setTimeout(async () => {
    clearInterval(shakeInt);
    diceEl.classList.remove('rolling');
    diceEl.textContent = ['⚀','⚁','⚂','⚃','⚄','⚅'][result-1];
    statusEl.textContent = `رميت ${result}! تتحرك...`;

    await movePlayer('me', result);
    await landOn('me');

    // إذا اللاعب ما زال بالشراء، نوقف
    if (state.phase === 'buying') return;

    // دور الخصم
    setTimeout(aiTurn, 800);
  }, 700);
}

// ============ دور الخصم ============
async function aiTurn() {
  if (state.myMoney <= 0 || state.aiMoney <= 0) return;
  state.turn = 'ai';
  statusEl.textContent = '🤖 دور الخصم...';

  const result = Math.floor(Math.random() * 6) + 1;
  diceEl.textContent = ['⚀','⚁','⚂','⚃','⚄','⚅'][result-1];
  SFX.dice();

  await new Promise(r => setTimeout(r, 600));
  statusEl.textContent = `الخصم رمى ${result}!`;

  await movePlayer('ai', result);
  await landOn('ai');

  // رجوع الدور
  state.turn = 'me';
  state.phase = 'idle';
  rollBtn.disabled = false;
  buyRow.style.display = 'none';
  statusEl.textContent = 'دورك! ارمِ النرد 🎲';

  checkWin();
}

// ============ فحص الفوز ============
function checkWin() {
  if (state.myMoney <= 0) {
    SFX.lose();
    showModal('😢 خسرت', 'نفدت فلوسك!', '💔', resetGame);
  } else if (state.aiMoney <= 0) {
    SFX.win();
    showModal('🏆 فزت!', 'أفلست الخصم! مبروك!', '🎉', resetGame);
  }
}

// ============ إعادة ============
function resetGame() {
  state.myMoney = 1000;
  state.aiMoney = 1000;
  state.myPos = 0;
  state.aiPos = 0;
  state.owners = {};
  state.turn = 'me';
  state.phase = 'idle';
  state.canBuy = false;
  diceEl.textContent = '🎲';
  rollBtn.disabled = false;
  buyRow.style.display = 'none';
  statusEl.textContent = 'دورك! ارمِ النرد 🎲';
  updateUI();
}

// ============ الشراء ============
buyBtn.onclick = () => {
  const pos = state.myPos;
  const cell = BOARD[pos];
  if (state.myMoney >= cell.price) {
    state.myMoney -= cell.price;
    state.owners[pos] = 'me';
    SFX.buy();
    updateUI();
    showModal('🎉 اشتريت!', `اشتريت ${cell.name} بـ $${cell.price}`, '🏠', () => {
      finishBuyTurn();
    });
  } else {
    SFX.rent();
    showModal('💸 ماكو فلوس', 'ما عندك فلوس كافية!', '😅', finishBuyTurn);
  }
};

skipBtn.onclick = () => {
  SFX.pass();
  finishBuyTurn();
};

function finishBuyTurn() {
  state.phase = 'idle';
  buyRow.style.display = 'none';
  rollBtn.disabled = true;
  statusEl.textContent = '🤖 دور الخصم...';
  setTimeout(aiTurn, 600);
}

// ============ ربط الأزرار ============
rollBtn.onclick = () => {
  initAudio();
  rollDice();
};

// ============ بدء ============
updateUI();
statusEl.textContent = 'دورك! ارمِ النرد 🎲';
</script>
</body>
</html>