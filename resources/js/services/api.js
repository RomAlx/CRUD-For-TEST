import axios from 'axios';

const api = axios.create({
    baseURL: '/api/v1',
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    }
});

api.interceptors.response.use(
    response => response,
    error => {
        if (error.response?.status === 422) {
            return Promise.reject(error);
        }

        console.error('API Error:', error.response?.data?.message || 'Something went wrong');
        return Promise.reject(error);
    }
);

export const userApi = {
    // Получение списка пользователей с пагинацией
    getAll(page = 1) {
        return api.get(`/users?page=${page}`);
    },

    // Получение одного пользователя
    getById(id) {
        return api.get(`/users/${id}`);
    },

    // Создание пользователя
    create(userData) {
        return api.post('/users', userData);
    },

    // Обновление пользователя
    update(id, userData) {
        return api.put(`/users/${id}`, userData);
    },

    // Удаление пользователя
    delete(id) {
        return api.delete(`/users/${id}`);
    }
};
