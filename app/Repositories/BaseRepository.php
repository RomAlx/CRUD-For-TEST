<?php

namespace App\Repositories;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Pagination\LengthAwarePaginator;

abstract class BaseRepository
{
    /**
     * Модель для работы с репозиторием.
     *
     * @var Model
     */
    protected $model;

    /**
     * Получить список всех записей с пагинацией.
     *
     * @param int $perPage
     * @param string $sortField
     * @param string $sortOrder
     * @return LengthAwarePaginator
     */
    public function getAll(int $perPage = 10, string $sortField = 'id', string $sortOrder = 'asc'): LengthAwarePaginator
    {
        return $this->model->orderBy($sortField, $sortOrder)->paginate($perPage);
    }

    /**
     * Найти запись по ID.
     *
     * @param int $id
     * @return Model
     */
    public function findById(int $id): Model
    {
        return $this->model->findOrFail($id);
    }

    /**
     * Создать новую запись.
     *
     * @param array $data
     * @return Model
     */
    public function create(array $data): Model
    {
        return $this->model->create($data);
    }

    /**
     * Обновить запись.
     *
     * @param Model $model
     * @param array $data
     * @return Model
     */
    public function update(Model $model, array $data): Model
    {
        $model->update($data);
        return $model;
    }

    /**
     * Удалить запись.
     *
     * @param Model $model
     * @return void
     */
    public function delete(Model $model): void
    {
        $model->delete();
    }
}
