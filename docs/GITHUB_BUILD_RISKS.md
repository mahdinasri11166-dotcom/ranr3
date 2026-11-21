# ریسک‌های بیلد GitHub و وضعیت اصلاح

## ورک‌فلوها

| Workflow | وضعیت | ریسک باقی‌مانده |
|----------|--------|------------------|
| `ci-selftest.yml` | پایدار | نیاز به deps سبک pip |
| `release-portable.yml` | اصلاح شد (staging zip) | فقط سورس؛ Python آفلاین ندارد |
| `release.yml` | hardened + size check | دانلود llama-server از شبکه |
| `build-nsis.yml` | اصلی آفلاین | بیشترین ریسک (جدول زیر) |
| `build-installer.yml` | Inno نازک، فقط دستی | نسخه Setup کامل آفلاین نیست |

## خطاهای تاریخی (۷ مورد) — پوشش داده شده

1. YAML indentation → فایل‌ها validate می‌شوند  
2. llama-server ۹KB → fail اگر &lt; 1MB + لینک pinned  
3. llama-cpp بدون wheel → abetlen CPU index + scikit-build-core  
4–7. tkinter/tcl روی embed → کپی از Python کامل + `._pth` + `TCL_LIBRARY`/`TK_LIBRARY` در CI و `env_python.bat`

## ریسک‌های باقی‌مانده (خارج از کنترل کامل کد)

| ریسک | احتمال | اثر | mitigation |
|------|--------|------|------------|
| abetlen wheel برای نسخهٔ جدید Python/OS نباشد | متوسط | NSIS قرمز | Strategy 2 only-binary؛ قفل 3.11.9 |
| نام assetهای llama.cpp عوض شود | متوسط | دانلود fail | fallback API + pinned b8581 |
| choco NSIS/python timeout | کم | fail موقت | re-run workflow |
| Rate limit GitHub API | کم | fail دانلود | User-Agent + pinned URL |
| Inno `build-installer` با کاربر اشتباه گرفته شود | متوسط | Setup بدون offline python | فقط workflow_dispatch؛ README می‌گوید NSIS اصلی است |

## چک‌لیست قبل از اعتماد به Artifact

- [ ] جاب **سبز** است  
- [ ] Artifact حجم معقول دارد (Setup معمولاً صدها MB)  
- [ ] بعد از نصب: `CHAT.bat` بدون خطای tkinter  
- [ ] `import llama_cpp` و `import customtkinter`  
- [ ] مدل `.gguf` در `models\`

## اگر جاب قرمز شد

1. لاگ همان step را باز کنید (نه فقط summary)  
2. اگر `llama-cpp-python` → لاگ pip و URL wheel  
3. اگر `tcl8.6 not copied` → choco python311 / sys.prefix  
4. اگر `makensis failed` → File مفقود در NSIS (الان فایل‌های اجباری در ریپو چک شدند)  
