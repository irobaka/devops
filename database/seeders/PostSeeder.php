<?php

namespace Database\Seeders;

use App\Models\Post;
use Illuminate\Database\Seeder;

class PostSeeder extends Seeder
{
    public function run(): void
    {
        Post::firstOrCreate([
            'title' => 'Kres w Vesperze',
            'body' => 'W przyszłym roku Vesper planuje wydać trzytomowy cykl Feliksa W. Kresa pt. "Zjednoczone Królestwa"
             - czyli książki "Strażnicza istnień", "Piekło i szpada" oraz "Klejnot i wachlarz".Do każdego tomu posłowie
              napisze Arkady Saulski, który obecnie pracuje także nad dokończeniem innej serii Kresa - "Księgi Całości".',
        ]);

        Post::firstOrCreate([
            'title' => 'Ostrze Erkal po raz drugi',
            'body' => 'Pod koniec maja Initium wyda "Pieśń zemsty" Grzegorza Wielgusa.'
        ]);

        Post::firstOrCreate([
            'title' => 'Historia Śródziemia #4',
            'body' => 'Wydawnictwo Zysk i S-ka przedstawia czwarty tom Historii Śródziemia. "Kształtowanie Śródziemia"
            Johna Ronalda Ruela Tolkiena ma zaplanowaną premierę na 21 maja 2024 roku.'
        ]);

        Post::firstOrCreate([
            'title' => 'King Kong nadejdzie wiosną',
            'body' => 'Jeszcze tej wiosny Nowa Baśń planuje wydać "King Konga" Delosa W. Lovelace\'a.'
        ]);

        Post::firstOrCreate([
            'title' => 'Nowa Fantastyka #500',
            'body' => 'Do sprzedaży trafił majowy, pięćsetny numer miesięcznika Nowa Fantastyka.'
        ]);

        Post::firstOrCreate([
            'title' => 'Lem wraca',
            'body' => 'Wydawnictwo Literackie prezentuje następne wznowienie książki Stanisława Lema.
             "Wielkość urojona" ma ustaloną datę premiery na 15 maja 2024 roku.'
        ]);
    }
}
