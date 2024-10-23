import { createRouter, createWebHistory } from 'vue-router';
import UserList from '../components/users/UserList.vue';
import UserCreate from '../components/users/UserCreate.vue';
import UserEdit from '../components/users/UserEdit.vue';

const routes = [
    {
        path: '/',
        name: 'home',
        component: UserList
    },
    {
        path: '/users',
        name: 'users.index',
        component: UserList
    },
    {
        path: '/users/create',
        name: 'users.create',
        component: UserCreate
    },
    {
        path: '/users/:id/edit',
        name: 'users.edit',
        component: UserEdit
    }
];

export default createRouter({
    history: createWebHistory(),
    routes
});
