
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>GameHub</title>

<style>
* { box-sizing: border-box; }

body {
  margin: 0;
  background: #090912;
  color: white;
  font-family: Arial, sans-serif;
}

header {
  background: #151522;
  padding: 20px;
  border-bottom: 1px solid var(--accent);
}

.logo {
  color: var(--accent);
  font-size: 25px;
  font-weight: bold;
}

main {
  max-width: 750px;
  margin: auto;
  padding: 20px;
}

.card {
  background: #191927;
  border: 1px solid #39334d;
  border-radius: 16px;
  padding: 20px;
  margin: 18px 0;
}

button, select {
  padding: 12px;
  border: 0;
  border-radius: 9px;
  background: var(--accent);
  color: white;
  margin: 5px;
}

button { cursor: pointer; }

input {
  accent-color: var(--accent);
}

nav {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

nav button {
  flex: 1;
}

#result { color: #61e6a5; }

:root { --accent: #9147ff; }
</style>
</head>

<body>

<header>
  <div class="logo">GAMEHUB 🎮</div>
  <p>Gaming Control Center</p>
</header>

<main>

<nav>
  <button onclick="showPage('home')">الرئيسية</button>
  <button onclick="showPage('tools')">الأدوات</button>
  <button onclick="showPage('settings')">الإعدادات ⚙️</button>
</nav>

<section id="home" class="page">
  <div class="card">
    <h2>مرحباً بك في GameHub</h2>
    <p>منصتك الخاصة بأدوات الألعاب والتحكم.</p>
    <button onclick="checkAPI()">فحص API</button>
    <p id="result">لم يتم الفحص بعد.</p>
  </div>
</section>

<section id="tools" class="page" hidden>
  <div class="card">
    <h2>أدوات الألعاب 🎮</h2>
    <p>سيتم إضافة أدواتنا هنا تدريجياً.</p>
  </div>
</section>

<section id="settings" class="page" hidden>
  <div class="card">
    <h2>إعدادات الموقع ⚙️</h2>

    <p>لون الواجهة:</p>

    <select id="theme" onchange="changeTheme(this.value)">
      <option value="#9147ff">بنفسجي</option>
      <option value="#ff4081">وردي</option>
      <option value="#00bcd4">أزرق</option>
      <option value="#00d68f">أخضر</option>
    </select>

    <p>حجم الخط:</p>

    <input type="range" min="14" max="22"
      value="16" id="fontSize"
      oninput="changeFont(this.value)">

    <p>حجم الخط الحالي: <span id="fontValue">16</span></p>

    <button onclick="resetSettings()">إعادة الإعدادات</button>
  </div>
</section>

</main>

<script>
function showPage(page) {
  document.querySelectorAll(".page").forEach(item => {
    item.hidden = true;
  });

  document.getElementById(page).hidden = false;
}

function changeTheme(color) {
  document.documentElement.style.setProperty("--accent", color);
  localStorage.setItem("theme", color);
}

function changeFont(size) {
  document.body.style.fontSize = size + "px";
  document.getElementById("fontValue").textContent = size;
  localStorage.setItem("fontSize", size);
}

function resetSettings() {
  localStorage.removeItem("theme");
  localStorage.removeItem("fontSize");
  location.reload();
}

async function checkAPI() {
  const result = document.getElementById("result");

  try {
    const response = await fetch("/api/status");
    const data = await response.json();

    result.textContent =
      "الحالة: " + data.status +
      " | الإصدار: " + data.version;
  } catch (error) {
    result.textContent = "فشل الاتصال";
  }
}

const savedTheme = localStorage.getItem("theme");
const savedFont = localStorage.getItem("fontSize");

if (savedTheme) {
  document.getElementById("theme").value = savedTheme;
  changeTheme(savedTheme);
}

if (savedFont) {
  document.getElementById("fontSize").value = savedFont;
  changeFont(savedFont);
}
</script>

</body>
</html>

