document.addEventListener('DOMContentLoaded', function() {
    // Обработчик для солнечных вспышек
    document.getElementById('fetch-solar-flares').addEventListener('click', function() {
        fetch('http://localhost:3000/api/solar-flares')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Ошибка получения данных о солнечных вспышках');
                }
                return response.json();
            })
            .then(data => {
                // Логируем данные в консоль
                console.log('Данные о солнечных вспышках:', data);
            })
            .catch(error => console.error(error));
    });

    // Обработчик для геомагнитных бурь
    document.getElementById('fetch-geomagnetic-storms').addEventListener('click', function() {
        fetch('http://localhost:3000/api/geomagneticstorms')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Ошибка получения данных о геомагнитных бурях');
                }
                return response.json();
            })
            .then(data => {
                // Логируем данные в консоль
                console.log('Данные о геомагнитных бурях:', data);
            })
            .catch(error => console.error(error));
    });

    // Обработчик для резких изменений
    document.getElementById('fetch-rapid-bursts').addEventListener('click', function() {
        fetch('http://localhost:3000/api/rapid-bursts')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Ошибка получения данных о резких изменениях');
                }
                return response.json();
            })
            .then(data => {
                // Логируем данные в консоль
                console.log('Данные о резких изменениях:', data);
            })
            .catch(error => console.error(error));
    });
});
