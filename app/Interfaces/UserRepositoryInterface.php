<?php

namespace App\Interfaces;

use App\Models\User;
use Illuminate\Pagination\LengthAwarePaginator;

interface UserRepositoryInterface
{
    /**
     * Получить список всех пользователей с пагинацией.
     *
     * @param int $perPage
     * @param string $sortField
     * @param string $sortOrder
     * @return LengthAwarePaginator
     */
    public function getAllUsers(int $perPage = 10, string $sortField = 'id', string $sortOrder = 'asc'): LengthAwarePaginator;

    /**
     * Создать нового пользователя.
     *
     * @param array $data
     * @return User
     */
    public function createUser(array $data): User;

    /**
     * Получить данные пользователя по его ID.
     *
     * @param int $userId
     * @return User
     */
    public function getUserById(int $userId): User;

    /**
     * Обновить данные пользователя.
     *
     * @param User $user
     * @param array $data
     * @return User
     */
    public function updateUser(User $user, array $data): User;

    /**
     * Удалить пользователя.
     *
     * @param User $user
     * @return void
     */
    public function deleteUser(User $user): void;
}
