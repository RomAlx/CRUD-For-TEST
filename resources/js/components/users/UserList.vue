<template>
    <v-card>
        <v-card-title>
            Users
            <v-spacer></v-spacer>
            <v-btn
                color="primary"
                @click="$router.push({ name: 'users.create' })"
            >
                Add User
            </v-btn>
        </v-card-title>

        <v-card-text>
            <v-table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="user in users" :key="user.id">
                    <td>{{ user.id }}</td>
                    <td>{{ user.name }}</td>
                    <td>{{ user.email }}</td>
                    <td>
                        <v-btn
                            icon
                            size="small"
                            color="primary"
                            @click="$router.push({ name: 'users.edit', params: { id: user.id }})"
                        >
                            <v-icon>mdi-pencil</v-icon>
                        </v-btn>
                        <v-btn
                            icon
                            size="small"
                            color="error"
                            @click="confirmDelete(user)"
                        >
                            <v-icon>mdi-delete</v-icon>
                        </v-btn>
                    </td>
                </tr>
                </tbody>
            </v-table>
        </v-card-text>
    </v-card>
</template>

<script setup>
import {ref, onMounted} from 'vue';
import axios from 'axios';

const users = ref([]);

const fetchUsers = async () => {
    try {
        const response = await axios.get('/api/users');
        users.value = response.data.data;
    } catch (error) {
        console.error('Error fetching users:', error);
    }
};

const confirmDelete = async (user) => {
    if (confirm(`Are you sure you want to delete ${user.name}?`)) {
        try {
            await axios.delete(`/api/users/${user.id}`);
            await fetchUsers();
        } catch (error) {
            console.error('Error deleting user:', error);
        }
    }
};

onMounted(fetchUsers);
</script>
