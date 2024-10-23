<template>
    <v-container>
        <v-card class="mb-6" elevation="2">
            <v-toolbar color="light-blue-darken-1" density="comfortable">
                <v-btn
                    icon="mdi-arrow-left"
                    variant="text"
                    class="mr-4"
                    color="white"
                    @click="$router.push({ name: 'users.index' })"
                />
                <v-toolbar-title class="text-white">Изменить пользователя</v-toolbar-title>
            </v-toolbar>
        </v-card>

        <v-card elevation="2">
            <v-card-text class="pa-6">
                <v-form @submit.prevent="handleSubmit" class="mt-4">
                    <v-row>
                        <v-col cols="12">
                            <v-text-field
                                v-model="form.name"
                                label="Имя"
                                :error-messages="errors.name"
                                variant="outlined"
                                required
                                prepend-inner-icon="mdi-account"
                                density="comfortable"
                                placeholder="Введите имя"
                                @update:model-value="clearError('name')"
                            />
                        </v-col>

                        <v-col cols="12">
                            <v-text-field
                                v-model="form.email"
                                label="Почта"
                                type="email"
                                :error-messages="errors.email"
                                variant="outlined"
                                required
                                prepend-inner-icon="mdi-email"
                                density="comfortable"
                                placeholder="Введите новую почту"
                                @update:model-value="clearError('email')"
                            />
                        </v-col>

                        <v-col cols="12">
                            <v-text-field
                                v-model="form.password"
                                label="Пароль"
                                type="password"
                                :error-messages="errors.password"
                                variant="outlined"
                                prepend-inner-icon="mdi-lock"
                                density="comfortable"
                                placeholder="Оставьте это поле пустым, чтобы сохранить предыдущий пароль"
                                hint="Оставьте это поле пустым, чтобы сохранить предыдущий пароль"
                                persistent-hint
                                @update:model-value="clearError('password')"
                            />
                        </v-col>
                    </v-row>

                    <v-divider class="my-4"></v-divider>

                    <v-row>
                        <v-col cols="12" class="d-flex justify-end">
                            <v-btn
                                variant="text"
                                class="mr-4"
                                size="large"
                                @click="$router.push({ name: 'users.index' })"
                            >
                                Отмена
                            </v-btn>
                            <v-btn
                                color="light-blue-darken-1"
                                type="submit"
                                :loading="loading"
                                :disabled="loading"
                                size="large"
                            >
                                Сохранить изменения
                            </v-btn>
                        </v-col>
                    </v-row>
                </v-form>
            </v-card-text>
        </v-card>

        <v-overlay
            :model-value="loading"
            class="align-center justify-center"
            persistent
        >
            <v-progress-circular
                color="primary"
                indeterminate
                size="64"
            ></v-progress-circular>
        </v-overlay>

        <v-snackbar
            v-model="snackbar.show"
            :color="snackbar.color"
            :timeout="2000"
            location="bottom"
        >
            {{ snackbar.text }}
            <template v-slot:actions>
                <v-btn
                    color="white"
                    variant="text"
                    icon="mdi-close"
                    @click="snackbar.show = false"
                />
            </template>
        </v-snackbar>
    </v-container>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { userApi } from '@/services/api';

const router = useRouter();
const route = useRoute();
const loading = ref(false);
const errors = ref({});
const form = ref({
    name: '',
    email: '',
    password: '',
});

const snackbar = ref({
    show: false,
    text: '',
    color: 'success'
});

const showSnackbar = (text, color = 'success') => {
    snackbar.value = { show: true, text, color };
};

const clearError = (field) => {
    if (errors.value[field]) {
        errors.value[field] = null;
    }
};

const fetchUser = async () => {
    try {
        const response = await userApi.getById(route.params.id);
        const user = response.data.data;
        form.value = {
            name: user.name,
            email: user.email,
            password: '',
        };
    } catch (error) {
        showSnackbar('Ошибка получения пользователя', 'error');
        router.push({ name: 'users.index' });
    }
};

const handleSubmit = async () => {
    loading.value = true;
    errors.value = {};

    try {
        const formData = { ...form.value };
        if (!formData.password) {
            delete formData.password;
        }

        await userApi.update(route.params.id, formData);
        showSnackbar('Пользователь обновлен успешно');
        router.push({ name: 'users.index' });
    } catch (error) {
        if (error.response?.data?.errors) {
            errors.value = error.response.data.errors;
        }
        showSnackbar('Ошибка сохранения изменений', 'error');
    } finally {
        loading.value = false;
    }
};

onMounted(fetchUser);
</script>
