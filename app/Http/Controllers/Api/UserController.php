<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\UserStoreRequest;
use App\Http\Requests\UserUpdateRequest;
use App\Http\Resources\UserResource;
use App\Interfaces\UserRepositoryInterface;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response as ResponseAlias;

class UserController extends Controller
{
    /**
     * Интерфейс для работы с репозиторием пользователей.
     *
     * @var UserRepositoryInterface
     */
    protected UserRepositoryInterface $userRepository;

    /**
     * Конструктор контроллера.
     *
     * @param UserRepositoryInterface $userRepository
     */
    public function __construct(UserRepositoryInterface $userRepository)
    {
        $this->userRepository = $userRepository;
    }

    /**
     * Получить список всех пользователей с пагинацией.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        $users = $this->userRepository->getAllUsers(10, 'id', 'asc')->through(function ($user) {
            return [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'created_at' => $user->created_at->format('Y-m-d H:i:s'),
            ];
        });

        return response()->json([
            'data' => $users->items(),
            'meta' => [
                'current_page' => $users->currentPage(),
                'last_page' => $users->lastPage(),
                'per_page' => $users->perPage(),
                'total' => $users->total(),
            ],
        ]);
    }

    /**
     * Создать нового пользователя.
     *
     * @param UserStoreRequest $request
     * @return JsonResponse
     */
    public function store(UserStoreRequest $request): JsonResponse
    {
        $user = $this->userRepository->createUser($request->validated());

        return response()->json([
            'message' => 'Пользователь успешно создан',
            'data' => new UserResource($user),
        ], ResponseAlias::HTTP_CREATED);
    }

    /**
     * Показать данные конкретного пользователя.
     *
     * @param int $userId
     * @return JsonResponse
     */
    public function show(int $userId): JsonResponse
    {
        $user = $this->userRepository->getUserById($userId);

        return response()->json([
            'data' => new UserResource($user),
        ]);
    }

    /**
     * Обновить данные существующего пользователя.
     *
     * @param UserUpdateRequest $request
     * @param int $userId
     * @return JsonResponse
     */
    public function update(UserUpdateRequest $request, int $userId): JsonResponse
    {
        $user = $this->userRepository->getUserById($userId);
        $updatedUser = $this->userRepository->updateUser($user, $request->validated());

        return response()->json([
            'message' => 'Пользователь успешно обновлён',
            'data' => new UserResource($updatedUser),
        ]);
    }

    /**
     * Удалить пользователя.
     *
     * @param int $userId
     * @return JsonResponse
     */
    public function destroy(int $userId): JsonResponse
    {
        $user = $this->userRepository->getUserById($userId);
        $this->userRepository->deleteUser($user);

        return response()->json([
            'message' => 'Пользователь успешно удалён',
        ], ResponseAlias::HTTP_OK);
    }
}
