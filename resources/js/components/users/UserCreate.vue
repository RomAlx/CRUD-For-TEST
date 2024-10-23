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
                <v-toolbar-title class="text-white">Добавить пользователя</v-toolbar-title>
            </v-toolbar>
        </v-card>

        <v-card elevation="2">
            <v-card-text class="pa-6">
                <v-form @submit.prevent="handleSubmit" class="mt-4">
                    <v-row>
                        <v-col cols="12">
                            <v-text-field
                                v-model="formData.name"
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
                                v-model="formData.email"
                                label="Почта"
                                type="email"
                                :error-messages="errors.email"
                                variant="outlined"
                                required
                                prepend-inner-icon="mdi-email"
                                density="comfortable"
                                placeholder="Введите почту"
                                @update:model-value="clearError('email')"
                            />
                        </v-col>

                        <v-col cols="12">
                            <v-text-field
                                v-model="formData.password"
                                label="Пароль"
                                type="password"
                                :error-messages="errors.password"
                                variant="outlined"
                                required
                                prepend-inner-icon="mdi-lock"
                                density="comfortable"
                                placeholder="Введите пароль"
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
                                Создать пользователя
                            </v-btn>
                        </v-col>
                    </v-row>
                </v-form>
            </v-card-text>
        </v-card>

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
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { userApi } from '@/services/api';

const router = useRouter();
const loading = ref(false);
const errors = ref({});

const formData = ref({
    name: '',
    email: '',
    password: ''
});

const snackbar = ref({
    show: false,
    text: '',
    color: 'success'
});

const showSnackbar = (text, color = 'success') => {
    snackbar.value = {
        show: true,
        text,
        color
    };
};

const clearError = (field) => {
    if (errors.value[field]) {
        errors.value[field] = null;
    }
};

const handleSubmit = async () => {
    try {
        loading.value = true;
        errors.value = {};

        const response = await userApi.create({
            name: formData.value.name,
            email: formData.value.email,
            password: formData.value.password
        });

        showSnackbar('Пользователь создан успешно');

        setTimeout(() => {
            router.push({ name: 'users.index' });
        }, 1000);

    } catch (error) {
        console.error('Creation error:', error);

        if (error.response?.data?.errors) {
            errors.value = error.response.data.errors;
            showSnackbar('Пожалуйста, перепроверьте поля формы', 'error');
        } else {
            showSnackbar(error.response?.data?.message || 'Ошибка создания пользователя', 'error');
        }
    } finally {
        loading.value = false;
    }
};
</script>
