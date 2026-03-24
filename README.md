# HİCRET — LÖVE 2D Oyun Projesi

**DUT Interdisciplinary Design Agency**  
Tür: Narrative / Survival Strategy  
Motor: LÖVE 2D 11.x (Lua)  
Platform: Android · iOS · Web (love.js)

---

## Kurulum

### LÖVE 2D kurulumu
1. https://love2d.org adresinden LÖVE 2D 11.5 indir
2. Bu klasörü LÖVE ile çalıştır:

```bash
# Linux/Mac
love /path/to/hicret/

# Windows
"C:\Program Files\LOVE\love.exe" C:\path\to\hicret\

# macOS (drag & drop de çalışır)
open -a love /path/to/hicret/
```

### Web (love.js)
```bash
npm install -g love.js
love.js /path/to/hicret/ output/ --title "Hicret"
# output/ klasörünü bir HTTP sunucusunda sun
```

### Android
```bash
# love-android repo: https://github.com/love2d/love-android
# hicret/ klasörünü .love dosyasına dönüştür:
cd hicret && zip -9 ../hicret.love -r .
# love-android/app/src/main/assets/ içine koy
```

---

## Proje Yapısı

```
hicret/
├── main.lua                    ← Giriş noktası
├── conf.lua                    ← LÖVE pencere ayarları
│
├── src/
│   ├── states/
│   │   ├── boot.lua            ← Yükleme ekranı
│   │   ├── world_map.lua       ← Dünya haritası
│   │   ├── chapter.lua         ← Bölüm yöneticisi
│   │   ├── act.lua             ← Diyalog/karar sahnesi
│   │   ├── outcome.lua         ← Sonuç ekranı
│   │   └── archive.lua         ← Tanıklık arşivi
│   │
│   ├── systems/
│   │   ├── state_manager.lua   ← Sonlu durum makinesi
│   │   ├── narrative_engine.lua← JSON tabanlı anlatı motoru
│   │   ├── i18n.lua            ← Çok dilli destek (TR/EN/AR)
│   │   ├── save_system.lua     ← Kayıt/yükleme
│   │   └── input_manager.lua   ← Birleşik girdi (fare+dokunmatik)
│   │
│   └── utils/
│       ├── config.lua          ← Çözünürlük/viewport
│       ├── json.lua            ← Hafif JSON encode/decode
│       └── loader.lua          ← require yolu ayarı
│
├── data/
│   ├── chapters/
│   │   └── gaza.json           ← Gazze bölümü (3 perde)
│   └── i18n/
│       ├── tr.json             ← Türkçe UI metinleri
│       ├── en.json             ← İngilizce UI metinleri
│       └── chapter_gaza_tr.json← Gazze bölümü Türkçe metinler
│
└── assets/
    ├── fonts/                  ← .ttf fontlar buraya
    ├── images/                 ← .png görseller buraya
    └── sounds/                 ← .ogg sesler buraya
```

---

## Yeni Bölge Eklemek

Kod yazmadan yeni bölge eklenebilir:

1. `data/chapters/{id}.json` → oluştur (gaza.json'u kopyala, düzenle)
2. `data/i18n/chapter_{id}_tr.json` → diyalog metinleri
3. `src/states/world_map.lua` → REGIONS tablosuna yeni giriş ekle:
   ```lua
   { id="yeni_bolge", x=700, y=300, color={0.8,0.4,0.2}, tag="war" }
   ```
4. `src/systems/save_system.lua` → `_default()` içindeki `unlocked` listesine ekle (opsiyonel)

---

## Klavye Kısayolları (debug)

| Tuş | Fonksiyon |
|-----|-----------|
| `Ctrl+U` | Harita ekranında tüm bölgeleri aç |
| `ESC` | Haritaya dön |
| `SPACE / ENTER` | Diyalogda ilerle |
| `1-9` | Seçim yap |

---

## Teknik Notlar

### Çözünürlük sistemi
- Sanal çözünürlük: **1280×720**
- Tüm koordinatlar bu sanal uzayda; `Config.pushViewport()` ekranı ölçekler
- Telefon döndürme ve farklı boyutlar otomatik letterbox/pillarbox ile çözülür

### Anlatı motoru
- Tüm diyalog ve karar ağaçları **JSON dosyalarında**
- Motor kodu değişmeden yeni içerik, çeviri veya bölüm eklenebilir
- Koşullu seçenekler: `"condition": { "flag": "met_neighbor" }`
- Kaynak etkileri: `"effects": { "trust": 5, "food": -2 }`

### Kayıt sistemi
- `love.filesystem` kullanır — tüm platformlarda çalışır
- Web'de tarayıcı IndexedDB'ye yazılır (love.js davranışı)
- `SaveSystem.reset()` ile sıfırlanabilir

---

## Yol Haritası

- [ ] **Faz 1**: Bu iskelet + Gazze bölümü tamamlama
- [ ] **Faz 2**: Doğu Türkistan bölümü + Zulüm Ağı UI görseli
- [ ] **Faz 3**: Tüm 6 bölge + ses tasarımı + gerçek görseller
- [ ] **Faz 4**: Google Play + App Store + web portal

---

*"Haber programları istatistik verir; oyun ise sorumluluk yükler."*

---

## v0.4 — Ayarlar Ekranı

### Yeni: `src/states/settings.lua`
- **3 bölüm**: SES / DİL / HAKKINDA
- **SES**: Ambiyans ve SFX için bağımsız slider — sürükle & bırak, anlık önizleme
- **DİL**: TR / EN / AR seçimi, anlık arayüz güncelleme, AR için RTL uyarısı
- **HAKKINDA**: Proje meta bilgisi, versiyon, etik not

### Klavye kısayolları (güncel)
| Tuş | Fonksiyon |
|-----|-----------|
| `S` veya `,` | Ayarlar ekranını aç (her yerden) |
| `A` | Arşive git |
| `ESC` | Geri / Kapat |
| `←` `→` | Slider kontrolü (odaklanıldığında) |
| `TAB` | Sliderlar arası geçiş |
| `Ctrl+U` | Debug: tüm bölgeleri aç |
