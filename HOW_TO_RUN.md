# URL Shortener API

This is a Ruby on Rails 7 API application that provides functionality to shorten URLs and decode shortened URLs.

---
## Demo
Health-check url: https://url-shortener-service-fz9g.onrender.com/up

-  Encode endpoint: https://url-shortener-service-fz9g.onrender.com/api/v1/encode

-  Decode enpoint: https://url-shortener-service-fz9g.onrender.com/api/v1/decode

> **_NOTE:_**  The free instance deployed by render.com will spin down with inactivity, which can delay requests by 50 seconds or more.
---

## Prerequisites

Make sure you have the following installed on your machine:

- **Ruby**: Version 3.1.2
- **Rails**: Version 7.0 or higher  
- **PostgreSQL**: For database management  
- **Git**: For version control

---

## Installation Steps

### 1. Clone the Repository

Run the following command to clone the repository:

```bash
git clone https://github.com/Kaito-Kido/url_shortener_service.git
cd url_shortener_service
```

### 2. Install dependencies
Install ruby gems:
```
bundle install
```

### 3. Setup database
```
rails db:create db:migrate
```

### 4. Start the server
```
rails s
```

### 5. API endpoinst
**Decode URL:**
POST /api/v1/decode

Request body:
```json
{
  "url": "http://google.com/"
}
```

**Decode URL:**
POST /api/v1/decode

Request body:
```json
{
    "short_url": "http://localhost:3000/abc"
}
```