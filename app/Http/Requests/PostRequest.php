<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class PostRequest extends FormRequest
{
    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'title' => ['required', 'min:3'],
            'body' => ['required', 'min:30'],
        ];
    }

    public function authorize(): bool
    {
        return true;
    }
}
