# Sudoku

Jednostavna Sudoku igra napisana u SwiftUI-u.

## Funkcionalnosti

- Tri nivoa težine (Lako, Srednje, Teško)
- Brojač poteza
- Validacija poteza
- Čuvanje stanja igre
- Podrška za lokalizaciju
- Dark mode podrška

## Zahtevi

- iOS 16.0+
- Xcode 16.3+
- Swift 5.9+

## Instalacija

1. Klonirajte repozitorijum:
```bash
git clone https://github.com/sgazz/ukoduS.git
```

2. Otvorite `ukoduS.xcodeproj` u Xcode-u

3. Build i pokrenite aplikaciju

## Arhitektura

Projekat je organizovan prema MVVM arhitekturi:

- **Features/** - Glavne funkcionalnosti aplikacije
  - **Sudoku/** - Sudoku igra
    - **View/** - SwiftUI view-ovi
    - **ViewModel/** - ViewModel logika
- **Core/** - Jezgro aplikacije
  - **Models/** - Modeli podataka
  - **Services/** - Servisi za čuvanje podataka
- **UI/** - UI komponente
  - **Components/** - Zajedničke UI komponente
- **Resources/** - Resursi aplikacije
  - **en.lproj/** - Lokalizacija za engleski jezik

## Licenca

MIT License 