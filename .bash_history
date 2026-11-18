new = """body:before{
 content:"";
 position:fixed;
 inset:0;
 z-index:-1;
 pointer-events:none;
 background:
 radial-gradient(ellipse at 50% 20%, rgba(160,55,210,.30), transparent 48%),
 radial-gradient(ellipse at 5% 65%, rgba(230,65,155,.13), transparent 43%),
 radial-gradient(ellipse at 95% 85%, rgba(120,40,190,.16), transparent 45%),
 #100812;
}"""

s, n = re.subn(r'body:before\s*\{.*?\}', lambda m: new, s, count=1, flags=re.S)

if n:
    p.write_text(s)
    print("SUCCESS: Background updated")
else:
    print("ERROR: body:before not found")
PY

sed -n '10,32p' templates/index.html
python app.py
grep -n -E 'body:before|#wallpaper|BACKGROUND.png|background:' templates/index.html
nl -ba templates/index.html | sed -n '1,45p'
grep -n -i -E 'body|wallpaper|background|gradient|style' templates/index.html
nl -ba templates/index.html | sed -n '30,110p'
cp templates/index.html templates/index.before_glass_buttons.html
python3 - <<'PY'
from pathlib import Path

p = Path("templates/index.html")
s = p.read_text()

css = """
/* GAMEHUB - PREMIUM GLASS UI */
.glass,.card,.setting,.status,.nav{
 background:linear-gradient(145deg,rgba(255,255,255,.13),rgba(145,65,175,.09)) !important;
 border:1px solid rgba(255,255,255,.25);
 box-shadow:
  0 12px 30px rgba(0,0,0,.24),
  0 0 18px rgba(165,65,210,.10),
  inset 0 1px 1px rgba(255,255,255,.28);
 backdrop-filter:blur(18px);
 -webkit-backdrop-filter:blur(18px);
}

.card,.setting,.status{
 border-radius:20px;
 transition:transform .22s ease,box-shadow .22s ease,border-color .22s ease;
}

.card:active,.setting:active{
 transform:scale(.98);
}

button,.contact a,select{
 transition:all .2s ease;
}

.nav button,.status button,.contact a{
 color:white;
 border:1px solid rgba(255,255,255,.32);
 border-radius:14px;
 background:linear-gradient(135deg,rgba(255,255,255,.17),rgba(170,65,210,.17));
 box-shadow:inset 0 1px 1px rgba(255,255,255,.22),0 5px 15px rgba(0,0,0,.18);
 backdrop-filter:blur(12px);
 -webkit-backdrop-filter:blur(12px);
}

.nav button.active{
 background:linear-gradient(135deg,rgba(195,105,235,.42),rgba(255,105,180,.32));
 border:1px solid rgba(255,220,255,.65);
 box-shadow:0 0 16px rgba(190,80,230,.22),inset 0 1px 2px rgba(255,255,255,.4);
}

.nav button:active,.status button:active,.contact a:active{
 transform:scale(.96);
 box-shadow:inset 0 2px 8px rgba(0,0,0,.25);
}

.menu{
 border:1px solid rgba(255,255,255,.38);
 box-shadow:0 5px 20px rgba(160,65,210,.18),inset 0 1px 2px rgba(255,255,255,.35);
}

select{
 border:1px solid rgba(230,180,255,.48);
 box-shadow:inset 0 2px 8px rgba(0,0,0,.2);
}
"""

if "GAMEHUB - PREMIUM GLASS UI" in s:
    print("NOTICE: Glass design already exists. No duplicate added.")
elif "</style>" not in s:
    print("ERROR: style closing tag not found. No changes made.")
else:
    s = s.replace("</style>", css + "\n</style>", 1)
    p.write_text(s)
    print("SUCCESS: Premium glass design added.")
PY

grep -n -A8 'GAMEHUB - PREMIUM GLASS UI' templates/index.html
python app.py
nl -ba templates/index.html | sed -n '100,180p'
grep -n -i -E 'settings|language|theme|font|reset|telegram|whatsapp' templates/index.html
tail -n 120 templates/index.html
sed -n '180,270p' templates/index.html
cp templates/index.html templates/index.backup_settings.html
cat > /tmp/update_gamehub.py <<'PY'
from pathlib import Path
import re

p = Path("templates/index.html")
s = p.read_text(encoding="utf-8")

# زر التحديث بدل زر القائمة
old_header = '<div class="menu glass">☰</div>'
new_header = '<button class="refresh-btn glass" onclick="location.reload()" aria-label="تحديث الصفحة">⟳</button>'

if old_header not in s:
    raise SystemExit("لم أجد زر القائمة في header. لم يتم تعديل الملف.")

s = s.replace(old_header, new_header, 1)

# صفحة الإعدادات
settings = '''<section id="settings" class="page">
 <div class="welcome">
  <h1 id="settingsTitle">الإعدادات ⚙️</h1>
  <p id="settingsIntro">إدارة اللغة والتواصل ومعلومات الموقع</p>
 </div>

 <div class="setting glass">
  <h3 id="languageTitle">🌐 اللغة</h3>
  <p id="languageDesc">اختر لغة واجهة الموقع</p>
  <select id="languageChoice" onchange="changeLanguage(this.value)">
   <option value="ar">العربية</option>
   <option value="en">English</option>
  </select>
 </div>

 <div class="setting glass">
  <h3 id="contactTitle">📱 التواصل والدعم</h3>
  <p id="contactDesc">تواصل مع المطور أو أرسل بلاغاً عن مشكلة</p>
  <div class="contact">
   <a href="https://t.me/BNGXXXXX" target="_blank" rel="noopener">Telegram Group</a>
   <a href="https://t.me/salma_salma52" target="_blank" rel="noopener">Report a problem</a>
   <a href="https://wa.me/212631778009" target="_blank" rel="noopener">WhatsApp</a>
  </div>
 </div>

 <div class="setting glass">
  <h3 id="aboutTitle">ℹ️ حول GameHub</h3>
  <p id="aboutDescription">هذا الإصدار رقم 0.1.3. من الفئة الأولى. هذا الموقع يحمي بيانات اللاعب ويهدف إلى توفير مزايا متطورة ونسعى دائماً إلى تحقيق الأفضل!</p>
  <p id="versionText">الإصدار: 0.1.3</p>
  <p id="contributorsText">المساهمون: The developer SLMA MOCROS</p>
 </div>
</section>'''

pattern = r'<section id="settings" class="page">.*?</section>'
s, count = re.subn(pattern, settings, s, count=1, flags=re.S)
if count != 1:
    raise SystemExit("لم أتمكن من تحديد قسم الإعدادات. لم يكتمل التعديل.")

# إزالة تهيئة اللون والخط القديمة حتى لا تسبب أخطاء بعد حذف عناصرها
s = re.sub(
    r'const c=localStorage\.getItem\(\'gamehub-color\'\);.*?changeFont\(f\)\}',
    '',
    s,
    count=1,
    flags=re.S
)

# إضافة وظائف اللغة والترجمة
language_js = r'''
function changeLanguage(lang){
 const translations = {
  ar: {
   settingsTitle:'الإعدادات ⚙️',
   settingsIntro:'إدارة اللغة والتواصل ومعلومات الموقع',
   languageTitle:'🌐 اللغة',
   languageDesc:'اختر لغة واجهة الموقع',
   contactTitle:'📱 التواصل والدعم',
   contactDesc:'تواصل مع المطور أو أرسل بلاغاً عن مشكلة',
   aboutTitle:'ℹ️ حول GameHub',
   aboutDescription:'هذا الإصدار رقم 0.1.3. من الفئة الأولى. هذا الموقع يحمي بيانات اللاعب ويهدف إلى توفير مزايا متطورة ونسعى دائماً إلى تحقيق الأفضل!',
   versionText:'الإصدار: 0.1.3',
   contributorsText:'المساهمون: The developer SLMA MOCROS',
   navHome:'⌂ الرئيسية', navTools:'⚡ الأدوات', navSettings:'⚙ الإعدادات'
  },
  en: {
   settingsTitle:'Settings ⚙️',
   settingsIntro:'Manage language, contact and site information',
   languageTitle:'🌐 Language',
   languageDesc:'Choose the website language',
   contactTitle:'📱 Contact & Support',
   contactDesc:'Contact the developer or report a problem',
   aboutTitle:'ℹ️ About GameHub',
   aboutDescription:'This is version 0.1.3, first category. This website protects player data and aims to provide advanced features. We always strive to improve!',
   versionText:'Version: 0.1.3',
   contributorsText:'Contributors: The developer SLMA MOCROS',
   navHome:'⌂ Home', navTools:'⚡ Tools', navSettings:'⚙ Settings'
  }
 };
 const t=translations[lang] || translations.ar;
 document.documentElement.lang=lang;
 document.documentElement.dir=lang==='ar'?'rtl':'ltr';
 Object.keys(t).forEach(id=>{
  const el=document.getElementById(id);
  if(el) el.textContent=t[id];
 });
 const nav=document.querySelectorAll('.nav button');
 if(nav[0]) nav[0].textContent=t.navHome;
 if(nav[1]) nav[1].textContent=t.navTools;
 if(nav[2]) nav[2].textContent=t.navSettings;
 localStorage.setItem('gamehub-language',lang);
}
const savedLanguage=localStorage.getItem('gamehub-language') || 'ar';
const languageChoice=document.getElementById('languageChoice');
if(languageChoice){
 languageChoice.value=savedLanguage;
 changeLanguage(savedLanguage);
}
'''

s = s.replace('</script>', language_js + '\n</script>', 1)

# تنسيق زر التحديث
css = '''
.refresh-btn{
 width:42px;height:42px;border-radius:15px;
 display:grid;place-items:center;
 color:white;font-size:27px;font-weight:bold;
 cursor:pointer;
 border:1px solid rgba(255,255,255,.32);
 background:linear-gradient(135deg,rgba(255,255,255,.17),rgba(170,65,210,.17));
 box-shadow:inset 0 1px 1px rgba(255,255,255,.22),0 5px 15px rgba(0,0,0,.18);
}
.refresh-btn:active{transform:rotate(90deg) scale(.94)}
'''
s = s.replace('</style>', css + '\n</style>', 1)

p.write_text(s, encoding="utf-8")
print("تم تحديث صفحة الإعدادات وإضافة زر التحديث.")
PY

python /tmp/update_gamehub.py
grep -n -E 'refresh-btn|languageChoice|BNGXXXXX|wa.me|0.1.3|changeLanguage' templates/index.html
python app.py
cd ~/GameHub
echo "=== 1. فحص التعديلات ==="
grep -n -E 'refresh-btn|languageChoice|BNGXXXXX|wa.me/212631778009' templates/index.html
echo "=== 2. فحص زر القائمة القديم ==="
grep -n 'menu glass' templates/index.html
echo "=== 3. فحص JavaScript ==="
python -m py_compile app.py
python app.py
cd ~/GameHub && pwd && ls -l templates/index.html && grep -n "refresh-btn" templates/index.html
pwd
grep -n -E 'refresh-btn|languageChoice|BNGXXXXX|wa.me/212631778009' templates/index.html
sed -n '160,175p' templates/index.html
cat > /tmp/fix_gamehub.py <<'PY'
from pathlib import Path
import re
import shutil

p = Path("templates/index.html")
s = p.read_text(encoding="utf-8")

# نسخة احتياطية
shutil.copy2(p, "templates/index.before_settings_fix.html")

# استبدال زر القائمة بزر تحديث
old = '<div class="menu glass">☰</div>'
new = '<button class="refresh-btn glass" onclick="location.reload()" aria-label="تحديث">⟳</button>'

if old not in s:
    raise SystemExit("خطأ: لم أجد زر القائمة. لم يتم حفظ التعديلات.")

s = s.replace(old, new, 1)

# استبدال صفحة الإعدادات
settings = r'''<section id="settings" class="page">
 <div class="welcome"><h1 id="settingsTitle">الإعدادات ⚙️</h1><p id="settingsIntro">إدارة اللغة والتواصل ومعلومات الموقع</p></div>

 <div class="setting glass">
  <h3 id="languageTitle">🌐 اللغة</h3>
  <p id="languageDesc">اختر لغة الموقع</p>
  <select id="languageChoice" onchange="changeLanguage(this.value)">
   <option value="ar">العربية</option>
   <option value="en">English</option>
  </select>
 </div>

 <div class="setting glass">
  <h3 id="contactTitle">📱 التواصل والدعم</h3>
  <p id="contactDesc">تواصل مع المطور أو أبلغ عن مشكلة</p>
  <div class="contact">
   <a href="https://t.me/BNGXXXXX" target="_blank" rel="noopener">Telegram Group</a>
   <a href="https://t.me/salma_salma52" target="_blank" rel="noopener">Report a problem</a>
   <a href="https://wa.me/212631778009" target="_blank" rel="noopener">WhatsApp</a>
  </div>
 </div>

 <div class="setting glass">
  <h3 id="aboutTitle">ℹ️ حول GameHub</h3>
  <p id="aboutDescription">هذا الإصدار رقم 0.1.3. من الفئة الأولى. هذا الموقع يحمي بيانات اللاعب ويهدف إلى توفير مزايا متطورة ونسعى دائماً إلى تحقيق الأفضل!</p>
  <p id="versionText">الإصدار: 0.1.3</p>
  <p id="contributorsText">المساهمون: The developer SLMA MOCROS</p>
 </div>
</section>'''

s, n = re.subn(
    r'<section id="settings" class="page">.*?</section>',
    lambda m: settings, s, count=1, flags=re.S
)
if n != 1:
    raise SystemExit("خطأ: لم أتمكن من استبدال صفحة الإعدادات.")

# استبدال JavaScript مع الحفاظ على التنقل وفحص API
js = r'''<script>
function openPage(id,btn){
 document.querySelectorAll('.page').forEach(p=>p.classList.remove('active'));
 document.getElementById(id).classList.add('active');
 document.querySelectorAll('.nav button').forEach(b=>b.classList.remove('active'));
 btn.classList.add('active');
 window.scrollTo({top:0,behavior:'smooth'});
}

async function checkAPI(){
 const state=document.getElementById('serverState');
 const result=document.getElementById('apiResult');
 state.textContent='جارٍ الفحص...';
 try{
  const r=await fetch('/api/status');
  if(!r.ok) throw Error('HTTP '+r.status);
  const d=await r.json();
  state.textContent='● متصل بنجاح';
  result.textContent='المشروع: '+d.project+' | الإصدار: '+d.version;
 }catch(e){
  state.textContent='● تعذر الاتصال';
  result.textContent='تحقق من تشغيل الخادم.';
 }
}

function changeLanguage(lang){
 const t = {
  ar:{
   settingsTitle:'الإعدادات ⚙️',settingsIntro:'إدارة اللغة والتواصل ومعلومات الموقع',
   languageTitle:'🌐 اللغة',languageDesc:'اختر لغة الموقع',
   contactTitle:'📱 التواصل والدعم',contactDesc:'تواصل مع المطور أو أبلغ عن مشكلة',
   aboutTitle:'ℹ️ حول GameHub',
   aboutDescription:'هذا الإصدار رقم 0.1.3. من الفئة الأولى. هذا الموقع يحمي بيانات اللاعب ويهدف إلى توفير مزايا متطورة ونسعى دائماً إلى تحقيق الأفضل!',
   versionText:'الإصدار: 0.1.3',contributorsText:'المساهمون: The developer SLMA MOCROS',
   home:'⌂ الرئيسية',tools:'⚡ الأدوات',settings:'⚙ الإعدادات'
  },
  en:{
   settingsTitle:'Settings ⚙️',settingsIntro:'Language, contact and website information',
   languageTitle:'🌐 Language',languageDesc:'Choose website language',
   contactTitle:'📱 Contact & Support',contactDesc:'Contact the developer or report a problem',
   aboutTitle:'ℹ️ About GameHub',
   aboutDescription:'Version 0.1.3, first category. This website protects player data and aims to provide advanced features. We always strive to improve!',
   versionText:'Version: 0.1.3',contributorsText:'Contributors: The developer SLMA MOCROS',
   home:'⌂ Home',tools:'⚡ Tools',settings:'⚙ Settings'
  }
 };
 const v=t[lang] || t.ar;
 Object.keys(v).forEach(id=>{
  const el=document.getElementById(id);
  if(el) el.textContent=v[id];
 });
 const nav=document.querySelectorAll('.nav button');
 if(nav[0]) nav[0].textContent=v.home;
 if(nav[1]) nav[1].textContent=v.tools;
 if(nav[2]) nav[2].textContent=v.settings;
 document.documentElement.lang=lang;
 document.documentElement.dir=lang==='ar'?'rtl':'ltr';
 localStorage.setItem('gamehub-language',lang);
}

const saved=localStorage.getItem('gamehub-language') || 'ar';
document.getElementById('languageChoice').value=saved;
changeLanguage(saved);
</script>'''

s, n = re.subn(r'<script>.*?</script>', lambda m: js, s, count=1, flags=re.S)
if n != 1:
    raise SystemExit("خطأ: لم أتمكن من استبدال JavaScript.")

css = r'''
.refresh-btn{
 width:42px;height:42px;border-radius:15px;
 display:grid;place-items:center;color:white;
 font-size:27px;font-weight:bold;cursor:pointer;
 border:1px solid rgba(255,255,255,.32);
 background:linear-gradient(135deg,rgba(255,255,255,.17),rgba(170,65,210,.17));
 box-shadow:inset 0 1px 1px rgba(255,255,255,.22),0 5px 15px rgba(0,0,0,.18);
}
.refresh-btn:active{transform:scale(.94) rotate(90deg)}
'''

if '.refresh-btn{' not in s:
    s = s.replace('</style>', css + '\n</style>', 1)

p.write_text(s, encoding="utf-8")

# التحقق من وجود العناصر المطلوبة
check = p.read_text(encoding="utf-8")
required = ['refresh-btn', 'languageChoice', 'BNGXXXXX',
            'wa.me/212631778009', 'changeLanguage']
missing = [x for x in required if x not in check]

if missing:
    print("تحذير: عناصر لم يتم العثور عليها:", missing)
else:
    print("نجاح: تم تعديل صفحة الإعدادات والشريط العلوي والتحقق من العناصر.")
PY

python /tmp/fix_gamehub.py
grep -n -E 'refresh-btn|languageChoice|wa.me|BNGXXXXX|changeLanguage' templates/index.html
python app.py
cd ~/GameHub
python app.py
cd ~
mv GameHub GameHub_old
mkdir GAME-S
cd GAME-S
mkdir templates static
mkdir static/images
termux-setup-storage
y
cp ~/storage/shared/Download/FOLOSA.png ~/GAME-S/static/images/background.png
ls -lh static/images/
nano templates/index.html
nano templates/index.htl
python -m http.server 8000
nano templates/index.html
-.
-.
-.
ls
python app.py
cd ~/GAME-S
python app.py
python -m http.server 8000
ped
pwd
ls

find ~ -type d -name "GAME-S" 2>/dev/null
cd ~/GAME-S
find . -maxdepth 3 -type f
ls -lh templates/
head -n 15 templates/index.html
python -m http.server 8000 --bind 127.0.0.1
pwd
ls -l templates/index.html
pwd
python -m http.server 8000 --bind 127.0.0.1
nano templates/index.html
nano templates/index.htl
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
nano templates/index.html
cd ~/GAME-S && cp templates/index.html /sdcard/Download/index.html
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
cp /sdcard/Download/V.png ~/GAME-S/static/images/V.png
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
ls -lh ~/GAME-S
cp ~/GAME-S/templates/index.html /sdcard/Download/GAME-S.html
ls -lh ~/GAME-S
ls-
ls ~
ls~
cd ~/GAME-S
cd ~
clear
cd
cd~/game-s
cd~/GAME-S
cd ~/GAME-S
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
nano ~/GAME-S/templates/index.html
cd ~/GAME-S && python -m http.server 8000 --bind 127.0.0.1
exite
exit
