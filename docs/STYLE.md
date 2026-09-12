# Lumen — стилистика

Референсы (сен 2026): `@martin_ouvre` клипы в Downloads — `IMG_3488`–`IMG_3491`.  
Берём *чувство*: тёмный luxury OS, светящиеся metric-блоки, smoked glass, воздух. Не копируем продукт один в один.

**Приоритет:** визуальный язык референсов важнее generic «anti-AI» правил (фиолетовый glow и gradient-карточки здесь осознанно — так в референсах).

---

## Характер

- Уголь, не чистый чёрный; тёплый deep charcoal
- Ambient bloom: мягкое фиолетовое/синее свечение за контентом (как на module-grid клипах)
- Акценты дисциплинированы: **градиентные hero-карточки** для ключевых метрик; red/blue — семантика (расход / календарь / доход)
- Тёплый cream — редкий luxury CTA (кнопки «Quick add»-уровня), не заливка экрана
- Soft mint — позитивный статус / toggle-on
- Тишина Linear/Monarch + liquid glass жесты iOS

---

## Палитра

| Token | Hex | Use |
|---|---|---|
| `bg` | `#090A0D` | Основной фон |
| `bgElevated` | `#0E1015` | Слой под glass / rail |
| `surface` | `#14161C` | Панели |
| `surfaceRaised` | `#1B1E27` | Карточки / поля |
| `text` | `#F4F2EC` | Основной текст |
| `textMuted` | `#8B919C` | Вторичный |
| `accentRed` | `#C53B4A` | Расход, серия, срочное |
| `accentBlue` | `#5B7CFF` | Календарь, доход, selected nav |
| `accentViolet` | `#8B6CFF` | Ambient glow, glass edge, module icons |
| `accentCream` | `#E6DDD0` | Редкий premium CTA |
| `accentMint` | `#5ECF9A` | Позитив / on-state |
| `gradDusk` | `#3D5AFE → #7C4DFF` | Hero metric (время / фокус) |
| `gradEmber` | `#FF6B3D → #FFB347` | Hero metric (деньги) |

- Стекло: fill белый ~7–9% + blur 28–36; волосяная обводка белый ~12% **или** violet ~18% на module tiles
- Внешнее свечение карточек: цвет градиента, alpha 12–18%, blur ~24 — не неон-пульсация
- Радиусы: **20–24** (карточки 20, панели 24, pills 28)
- Сетка: 8pt, воздуха больше прежнего (`pagePadding` 24)

---

## Типографика и иконки

- Семья: **Outfit** (геометричный sans; на iOS тоже Outfit — единый бренд, не смесь SF + Material)
- Display / big numbers: 36–44, weight 600–700, tracking −1…−1.4, tabular figures
- Greeting / section titles: крупные, почти «hero» на Today
- Labels: 11–12, muted, tracking +0.2
- Иконки: только Phosphor line/fill — без смеси наборов

---

## Glass / surfaces

1. **GlassSurface** — frosted панель (tab bar, rooms, settings)
2. **GlowCard** — surfaceRaised + тонкая luminous edge (модули, event rows)
3. **GradientMetricCard** — `gradDusk` / `gradEmber`, крупное число, мягкий outer glow

Карточки = контейнеры для взаимодействия / метрик. Не оборачивать каждый абзац в card.

---

## Движение

- Tab / page switch: 280–320ms, `easeOutCubic`
- Selected tab: soft scale 1.0 → 1.06 + color morph
- Entrance Today: лёгкий fade+slide-up блоков (не карусель)
- Никакого постоянного неона и bounce на каждый тап

---

## Layout

**Phone:** нижний floating glass island (не full-bleed bar на весь width), большие заголовки, safe area.

**Wide / web:** узкая rail слева, тот же язык — не другой продукт.

### Табы (5)

1. Today  
2. Calendar  
3. Tasks  
4. Finance  
5. More — Habits, Routine, Nutrition, Training, Settings

### Today (первый экран)

Одна композиция: greeting → ряд gradient metrics → upcoming events.  
Бренд «Lumen» не кричит логотипом — его несёт атмосфера (уголь + bloom + типографика).
