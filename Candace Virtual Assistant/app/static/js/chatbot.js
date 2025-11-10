// === DOM refs ===
const chatbotToggler = document.querySelector(".chatbot-toggler");
const closeBtn = document.querySelector(".close-btn");
const chatbox = document.querySelector(".chatbox");
const chatInput = document.querySelector(".chat-input textarea");
const sendChatBtn = document.querySelector(".chat-input span");

// === State ===
let isPending = false;
let userMessage = null;
const inputInitHeight = chatInput.scrollHeight;

// LocalStorage keys
const LS_KEYS = {
  history: "candace.chat.history",
  open: "candace.chat.open"
};

// Load persisted state
function loadState() {
  try {
    const historyRaw = localStorage.getItem(LS_KEYS.history);
    const openRaw = localStorage.getItem(LS_KEYS.open);
    const history = historyRaw ? JSON.parse(historyRaw) : [];
    const isOpen = openRaw === "true";
    return { history, isOpen };
  } catch {
    return { history: [], isOpen: false };
  }
}

function saveHistory(history) {
  localStorage.setItem(LS_KEYS.history, JSON.stringify(history));
}

function saveOpenState(isOpen) {
  localStorage.setItem(LS_KEYS.open, isOpen ? "true" : "false");
}

// In-memory mirror of history for convenience
let history = loadState().history; // [{role:"user"|"assistant", content:"..."}]

// === UI helpers ===
const createChatLi = (message, className) => {
  const chatLi = document.createElement("li");
  chatLi.classList.add("chat", className);
  let chatContent =
    className === "outgoing"
      ? `<p></p>`
      : `<span class="material-symbols-outlined" aria-hidden="true">smart_toy</span><p></p>`;
  chatLi.innerHTML = chatContent;
  chatLi.querySelector("p").textContent = message;
  return chatLi;
};

function appendMessage(role, content) {
  const className = role === "user" ? "outgoing" : "incoming";
  const li = createChatLi(content, className);
  chatbox.appendChild(li);
  chatbox.scrollTo(0, chatbox.scrollHeight);
}

function renderHistory() {
  chatbox.innerHTML = "";
  history.forEach(m => appendMessage(m.role, m.content));
}

function pushMessage(role, content) {
  history.push({ role, content });
  saveHistory(history);
  appendMessage(role, content);
}

function setPending(p) {
  isPending = p;
  sendChatBtn.style.pointerEvents = p ? "none" : "auto";
  sendChatBtn.style.opacity = p ? "0.4" : "1";
}

// === Network ===
async function generateResponse(incomingLi, userText) {
  const p = incomingLi.querySelector("p");
  try {
    // include short history (last 10 messages) for context
    const shortHistory = history.slice(-10);

    const res = await fetch("/chatbot", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      credentials: "same-origin", // include cookies/session if needed
      body: JSON.stringify({
        user_message: userText,
        history: shortHistory // server can use this to build context
      })
    });

    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();
    const botReply = (data.chatbot_response || "").toString().trim() || "(no response)";
    p.textContent = botReply;

    // Save assistant message to history
    pushMessage("assistant", botReply);
  } catch (err) {
    p.classList.add("error");
    p.textContent = "Oops! Something went wrong. Please try again.";
    console.error("Chat error:", err);
  } finally {
    setPending(false);
    chatbox.scrollTo(0, chatbox.scrollHeight);
  }
}

// === Chat flow ===
function handleChat() {
  if (isPending) return;

  userMessage = chatInput.value.trim();
  if (!userMessage) return;

  // Reset textarea
  chatInput.value = "";
  chatInput.style.height = `${inputInitHeight}px`;

  // Save and render user message
  pushMessage("user", userMessage);

  // Add a placeholder assistant line
  const incomingChatLi = createChatLi("Thinking...", "incoming");
  chatbox.appendChild(incomingChatLi);
  chatbox.scrollTo(0, chatbox.scrollHeight);

  setPending(true);
  generateResponse(incomingChatLi, userMessage);
}

// === Textarea behavior ===
chatInput.addEventListener("input", () => {
  chatInput.style.height = `${inputInitHeight}px`;
  chatInput.style.height = `${chatInput.scrollHeight}px`;
});

// Enter to send (ignore IME composition; Shift+Enter = newline)
chatInput.addEventListener("keydown", (e) => {
  if (e.isComposing || e.keyCode === 229) return; // IME guard
  if (e.key === "Enter" && !e.shiftKey) {
    e.preventDefault();
    handleChat();
  }
});

// Buttons
sendChatBtn.addEventListener("click", handleChat);

closeBtn.addEventListener("click", () => {
  document.body.classList.remove("show-chatbot");
  saveOpenState(false);
});

chatbotToggler.addEventListener("click", () => {
  const willOpen = !document.body.classList.contains("show-chatbot");
  document.body.classList.toggle("show-chatbot");
  saveOpenState(willOpen);
  if (willOpen) {
    setTimeout(() => chatInput.focus(), 150);
  }
});

// === Boot: restore history and open state ===
document.addEventListener("DOMContentLoaded", () => {
  const { isOpen } = loadState();
  renderHistory();
  if (isOpen) {
    document.body.classList.add("show-chatbot");
    setTimeout(() => chatInput.focus(), 150);
  }
});
