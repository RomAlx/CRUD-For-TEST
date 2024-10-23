<?php

namespace App\Repositories;

use App\Interfaces\UserRepositoryInterface;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Pagination\LengthAwarePaginator;

class UserRepository extends BaseRepository implements UserRepositoryInterface
{
    /**
     * Конструктор UserRepository.
     */
    public function __construct()
    {
        $this->model = new User();
    }

    /**
     * Получить список пользователей с пагинацией.
     *
     * @param int $perPage
     * @param string $sortField
     * @param string $sortOrder
     * @return LengthAwarePaginator
     */
    public function getAllUsers(int $perPage = 10, string $sortField = 'id', string $sortOrder = 'asc'): LengthAwarePaginator
    {
        return $this->getAll($perPage, $sortField, $sortOrder);
    }

    /**
     * Создать нового пользователя.
     *
     * @param array $data
     * @return User
     */
    public function createUser(array $data): User
    {
        $data['password'] = Hash::make($data['password']);
        return $this->create($data);
    }

    /**
     * Получить данные пользователя по его ID.
     *
     * @param int $userId
     * @return User
     */
    public function getUserById(int $userId): User
    {
        return $this->findById($userId);
    }

    /**
     * Обновить данные пользователя.
     *
     * @param User $user
     * @param array $data
     * @return User
     */
    public function updateUser(User $user, array $data): User
    {
        if (isset($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        }

        return $this->update($user, $data);
    }

    /**
     * Удалить пользователя.
     *
     * @param User $user
     * @return void
     */
    public function deleteUser(User $user): void
    {
        $this->delete($user);
    }
}
