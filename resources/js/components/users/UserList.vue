<template>
    <v-container>

        <v-card class="mb-4" elevation="2">
            <v-card-title class="d-flex justify-space-between align-center px-4">
                <h2 class="text-h5 font-weight-bold">Управление пользователями</h2>
                <v-btn
                    color="light-blue-darken-1"
                    prepend-icon="mdi-plus"
                    @click="$router.push({ name: 'users.create' })"
                >
                    Добавить пользователя
                </v-btn>
            </v-card-title>
        </v-card>

        <v-card elevation="2">
            <v-table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Имя</th>
                    <th>Почта</th>
                    <th>Создан</th>
                    <th>Действия</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="user in users" :key="user.id">
                    <td>{{ user.id }}</td>
                    <td>{{ user.name }}</td>
                    <td>{{ user.email }}</td>
                    <td>{{ user.created_at }}</td>
                    <td>
                        <v-btn
                            icon="mdi-pencil"
                            size="small"
                            color="light-blue-darken-1"
                            variant="text"
                            class="mr-2"
                            @click="editUser(user)"
                        />
                        <v-btn
                            icon="mdi-delete"
                            size="small"
                            color="red-darken-1"
                            variant="text"
                            @click="confirmDelete(user)"
                        />
                    </td>
                </tr>
                </tbody>
            </v-table>

            <div class="d-flex justify-center pa-4">
                <v-pagination
                    v-if="totalPages > 1"
                    v-model="currentPage"
                    :length="totalPages"
                    :total-visible="7"
                    rounded
                    @update:model-value="handlePageChange"
                />
            </div>
        </v-card>

        <v-dialog v-model="deleteDialog" max-width="400">
            <v-card>
                <v-card-title class="text-h5 bg-error text-white">
                    Подтверждение удаления
                </v-card-title>
                <v-card-text class="pt-4">
                    Вы уверены, что хотите удалить <b>{{ selectedUser?.name }}</b>?<br><br>
                    <i>Это действие не отменить.</i>
                </v-card-text>
                <v-card-actions>
                    <v-spacer />
                    <v-btn
                        color="grey-darken-1"
                        variant="text"
                        @click="closeDeleteDialog"
                    >
                        Отмена
                    </v-btn>
                    <v-btn
                        color="error"
                        variant="tonal"
                        @click="deleteUser"
                        :loading="deleteLoading"
                    >
                        Удалить
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-overlay
            :model-value="loading"
            class="align-center justify-center"
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
import { useRouter } from 'vue-router';
import { userApi } from '@/services/api';

const router = useRouter();
const users = ref([]);
const currentPage = ref(1);
const totalPages = ref(0);
const loading = ref(true);
const deleteLoading = ref(false);
const deleteDialog = ref(false);
const selectedUser = ref(null);
const snackbar = ref({
    show: false,
    text: '',
    color: 'success'
});

const showSnackbar = (text, color = 'success') => {
    snackbar.value = { show: true, text, color };
};

const fetchUsers = async (page) => {
    try {
        loading.value = true;
        const response = await userApi.getAll(page);
        users.value = response.data.data;
        totalPages.value = response.data.meta.last_page;
    } catch (error) {
        showSnackbar('Ошибка загрузки пользователей', 'error');
    } finally {
        loading.value = false;
    }
};

const handlePageChange = (page) => {
    currentPage.value = page;
    fetchUsers(page);
};

const editUser = (user) => {
    router.push({ name: 'users.edit', params: { id: user.id } });
};

const confirmDelete = (user) => {
    selectedUser.value = user;
    deleteDialog.value = true;
};

const closeDeleteDialog = () => {
    deleteDialog.value = false;
    selectedUser.value = null;
};

const deleteUser = async () => {
    if (!selectedUser.value?.id) return;

    try {
        deleteLoading.value = true;
        await userApi.delete(selectedUser.value.id);
        showSnackbar('Пользователь удален успешно');
        await fetchUsers(currentPage.value);
    } catch (error) {
        showSnackbar('Ошибка при удалении пользователя', 'error');
    } finally {
        deleteLoading.value = false;
        closeDeleteDialog();
    }
};

onMounted(() => {
    fetchUsers(1);
});
</script>
