# API Documentation - E-Learning Backend

## Base URL

```
http://localhost:8000/api
```

---

## USER ENDPOINTS

### 1. Get All Users

- **Method:** `GET`
- **URL:** `/users`
- **Response:**

```json
{
    "success": true,
    "message": "Data user berhasil diambil",
    "data": [
        {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "created_at": "2026-05-13T10:00:00.000000Z",
            "updated_at": "2026-05-13T10:00:00.000000Z"
        }
    ]
}
```

### 2. Get User by ID

- **Method:** `GET`
- **URL:** `/users/{id}`
- **Response:**

```json
{
    "success": true,
    "message": "Data user berhasil diambil",
    "data": {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com",
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 3. Create New User

- **Method:** `POST`
- **URL:** `/users`
- **Headers:** `Content-Type: application/json`
- **Request Body:**

```json
{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
}
```

- **Response (201):**

```json
{
    "success": true,
    "message": "User berhasil ditambahkan!",
    "data": {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com",
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 4. Update User

- **Method:** `PUT` or `PATCH`
- **URL:** `/users/{id}`
- **Headers:** `Content-Type: application/json`
- **Request Body (all optional):**

```json
{
    "name": "Jane Doe",
    "email": "jane@example.com",
    "password": "newpassword123"
}
```

- **Response:**

```json
{
    "success": true,
    "message": "User berhasil diperbarui!",
    "data": {
        "id": 1,
        "name": "Jane Doe",
        "email": "jane@example.com",
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 5. Delete User

- **Method:** `DELETE`
- **URL:** `/users/{id}`
- **Response:**

```json
{
    "success": true,
    "message": "User berhasil dihapus"
}
```

---

## TOPIC ENDPOINTS

### 1. Get All Topics

- **Method:** `GET`
- **URL:** `/topics`
- **Response:**

```json
{
    "success": true,
    "message": "Data topik berhasil diambil",
    "data": [
        {
            "id": 1,
            "title": "Laravel Basics",
            "description": "Learn the basics of Laravel framework",
            "price": "49.99",
            "is_free": false,
            "created_at": "2026-05-13T10:00:00.000000Z",
            "updated_at": "2026-05-13T10:00:00.000000Z"
        }
    ]
}
```

### 2. Get Topic by ID

- **Method:** `GET`
- **URL:** `/topics/{id}`
- **Response:**

```json
{
    "success": true,
    "message": "Data topik berhasil diambil",
    "data": {
        "id": 1,
        "title": "Laravel Basics",
        "description": "Learn the basics of Laravel framework",
        "price": "49.99",
        "is_free": false,
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 3. Create New Topic

- **Method:** `POST`
- **URL:** `/topics`
- **Headers:** `Content-Type: application/json`
- **Request Body:**

```json
{
    "title": "Laravel Basics",
    "description": "Learn the basics of Laravel framework",
    "price": 49.99,
    "is_free": false
}
```

- **Response (201):**

```json
{
    "success": true,
    "message": "Topik berhasil ditambahkan!",
    "data": {
        "id": 1,
        "title": "Laravel Basics",
        "description": "Learn the basics of Laravel framework",
        "price": "49.99",
        "is_free": false,
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 4. Update Topic

- **Method:** `PUT` or `PATCH`
- **URL:** `/topics/{id}`
- **Headers:** `Content-Type: application/json`
- **Request Body (all optional):**

```json
{
    "title": "Advanced Laravel",
    "description": "Advanced Laravel techniques",
    "price": 99.99,
    "is_free": false
}
```

- **Response:**

```json
{
    "success": true,
    "message": "Topik berhasil diperbarui!",
    "data": {
        "id": 1,
        "title": "Advanced Laravel",
        "description": "Advanced Laravel techniques",
        "price": "99.99",
        "is_free": false,
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 5. Delete Topic

- **Method:** `DELETE`
- **URL:** `/topics/{id}`
- **Response:**

```json
{
    "success": true,
    "message": "Topik berhasil dihapus"
}
```

---

## SPEAKING MATERIAL ENDPOINTS

### 1. Get All Speaking Materials

- **Method:** `GET`
- **URL:** `/speaking-materials`
- **Response:**

```json
[
    {
        "id": 1,
        "title": "Introduction to Public Speaking",
        "description": "Learn the basics of public speaking",
        "video": "videos/sample.mp4",
        "pdf": "pdfs/sample.pdf",
        "video_url": "http://localhost:8000/storage/videos/sample.mp4",
        "pdf_url": "http://localhost:8000/storage/pdfs/sample.pdf",
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
]
```

### 2. Get Speaking Material by ID

- **Method:** `GET`
- **URL:** `/speaking-materials/{id}`
- **Response:**

```json
{
    "success": true,
    "message": "Data materi berhasil diambil",
    "data": {
        "id": 1,
        "title": "Introduction to Public Speaking",
        "description": "Learn the basics of public speaking",
        "video": "videos/sample.mp4",
        "pdf": "pdfs/sample.pdf",
        "video_url": "http://localhost:8000/storage/videos/sample.mp4",
        "pdf_url": "http://localhost:8000/storage/pdfs/sample.pdf",
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 3. Create New Speaking Material

- **Method:** `POST`
- **URL:** `/speaking-materials`
- **Headers:** `Content-Type: multipart/form-data`
- **Request Body (Form Data):**
    - `title` (required) - string
    - `description` (optional) - string
    - `video` (required) - file (mp4, mov, avi)
    - `pdf` (optional) - file (pdf)

- **Response (201):**

```json
{
    "success": true,
    "message": "Materi berhasil ditambahkan!",
    "data": {
        "id": 1,
        "title": "Introduction to Public Speaking",
        "description": "Learn the basics of public speaking",
        "video": "videos/sample.mp4",
        "pdf": "pdfs/sample.pdf",
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 4. Update Speaking Material

- **Method:** `POST` (with `_method=PUT` in form data)
- **URL:** `/speaking-materials/{id}`
- **Headers:** `Content-Type: multipart/form-data`
- **Request Body (Form Data, all optional):**
    - `title` - string
    - `description` - string
    - `video` - file (mp4, mov, avi)
    - `pdf` - file (pdf)
    - `_method` - PUT

- **Response:**

```json
{
    "success": true,
    "message": "Materi berhasil diperbarui!",
    "data": {
        "id": 1,
        "title": "Advanced Public Speaking",
        "description": "Advanced techniques for public speaking",
        "video": "videos/advanced.mp4",
        "pdf": "pdfs/advanced.pdf",
        "created_at": "2026-05-13T10:00:00.000000Z",
        "updated_at": "2026-05-13T10:00:00.000000Z"
    }
}
```

### 5. Delete Speaking Material

- **Method:** `DELETE`
- **URL:** `/speaking-materials/{id}`
- **Response:**

```json
{
    "success": true,
    "message": "Materi berhasil dihapus"
}
```

### 6. Save Progress

- **Method:** `POST`
- **URL:** `/speaking-materials/progress`
- **Headers:** `Content-Type: application/json`
- **Request Body:**

```json
{
    "material_id": 1,
    "progress": 75,
    "user_id": 1
}
```

- **Response:**

```json
{
    "success": true,
    "message": "Progress berhasil disimpan"
}
```

---

## Error Responses

### 404 Not Found

```json
{
    "success": false,
    "message": "User tidak ditemukan"
}
```

### 422 Validation Error

```json
{
    "success": false,
    "message": "Validasi gagal",
    "errors": {
        "email": ["The email has already been taken."],
        "password": ["The password must be at least 6 characters."]
    }
}
```

### 500 Internal Server Error

```json
{
    "success": false,
    "message": "Gagal menambahkan user: [error details]"
}
```

---

## HTTP Status Codes

- `200` - OK
- `201` - Created
- `404` - Not Found
- `422` - Unprocessable Entity (Validation Error)
- `500` - Internal Server Error

---

## Validation Rules

### User Create/Update

- `name` - Required, string, max 255 characters
- `email` - Required (create), email format, unique (except on update)
- `password` - Required (create), string, minimum 6 characters

### Topic Create/Update

- `title` - Required, string, max 255 characters
- `description` - Optional, string
- `price` - Optional, numeric, minimum 0
- `is_free` - Optional, boolean

### Speaking Material Create/Update

- `title` - Required, string, max 255 characters
- `description` - Optional, string
- `video` - Required (create), file, mimes: mp4, mov, avi
- `pdf` - Optional, file, mimes: pdf
