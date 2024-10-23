<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class UserUpdateRequest extends FormRequest
{
    /**
     * Определить, авторизован ли пользователь для выполнения этого запроса.
     *
     * @return bool
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Правила валидации, применимые к запросу.
     *
     * @return array<string, array<int, string|object>>
     */
    public function rules(): array
    {
        return [
            'name' => [
                'sometimes',
                'required',
                'string',
                'max:255',
            ],
            'email' => [
                'sometimes',
                'required',
                'string',
                'email',
                'max:255',
                Rule::unique('users')->ignore($this->user->id ?? $this->route('user')),
            ],
            'password' => [
                'sometimes',
                'required',
                'string',
                'min:8',
            ],
        ];
    }

    /**
     * Сообщения об ошибках валидации.
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'name.required' => 'Поле имени обязательно для заполнения',
            'name.max' => 'Имя не может превышать :max символов',
            'email.required' => 'Поле электронной почты обязательно для заполнения',
            'email.email' => 'Введите корректный адрес электронной почты',
            'email.unique' => 'Этот адрес электронной почты уже зарегистрирован',
            'password.required' => 'Пароль обязателен для заполнения',
            'password.min' => 'Пароль должен содержать не менее :min символов',
        ];
    }
}
