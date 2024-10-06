document.getElementById('fetch-solar-flares').addEventListener('click', function() {
    fetch('http://localhost:3000/api/solar-flares')
        .then(response => {
            if (!response.ok) {
                throw new Error('Ошибка получения данных о солнечных вспышках');
            }
            return response.json();
        })
        .then(data => {
            console.log('Данные о солнечных вспышках:', data); // Вывод данных в консоль
            const container = document.getElementById('solar-flares');
            container.innerHTML = '';
            data.solarFlares.forEach(flare => {
                container.innerHTML += `<div>
                    <h5>ID: ${flare.flrID}</h5>
                    <p>Начало: ${flare.beginTime}</p>
                    <p>Пик: ${flare.peakTime}</p>
                    <p>Конец: ${flare.endTime}</p>
                    <p>Класс: ${flare.classType}</p>
                    <p>Локация: ${flare.sourceLocation}</p>
                    <p>Ссылка: <a href="${flare.link}" target="_blank">Посмотреть</a></p>
                </div><hr>`;
            });
        })
        .catch(error => console.error(error));
});

document.getElementById('fetch-geomagnetic-storms').addEventListener('click', function() {
    fetch('http://localhost:3000/api/geomagneticstorms')
        .then(response => {
            if (!response.ok) {
                throw new Error('Ошибка получения данных о геомагнитных бурях');
            }
            return response.json();
        })
        .then(data => {
            console.log('Данные о геомагнитных бурях:', data); // Вывод данных в консоль
            const container = document.getElementById('geomagnetic-storms');
            container.innerHTML = '';
            data.geomagneticStorms.forEach(storm => {
                container.innerHTML += `<div>
                    <h5>ID: ${storm.gstID}</h5>
                    <p>Начало: ${storm.startTime}</p>
                    <p>KP индекс: ${storm.kpIndex.map(kp => kp.kpIndex).join(', ')}</p>
                    <p>Связанные события: ${storm.linkedEvents.join(', ')}</p>
                    <p>Ссылка: <a href="${storm.link}" target="_blank">Посмотреть</a></p>
                </div><hr>`;
            });
        })
        .catch(error => console.error(error));
});

document.getElementById('fetch-rapid-bursts').addEventListener('click', function() {
    fetch('http://localhost:3000/api/rapid-bursts')
        .then(response => {
            if (!response.ok) {
                throw new Error('Ошибка получения данных о резких изменениях');
            }
            return response.json();
        })
        .then(data => {
            console.log('Данные о резких изменениях:', data); // Вывод данных в консоль
            const container = document.getElementById('rapid-bursts');
            container.innerHTML = '';
            data.rapidBursts.forEach(burst => {
                container.innerHTML += `<div>
                    <h5>ID: ${burst.rbeID}</h5>
                    <p>Начало: ${burst.beginTime}</p>
                    <p>Пик: ${burst.peakTime}</p>
                    <p>Конец: ${burst.endTime}</p>
                    <p>Класс: ${burst.classType}</p>
                    <p>Локация: ${burst.sourceLocation}</p>
                    <p>Ссылка: <a href="${burst.link}" target="_blank">Посмотреть</a></p>
                </div><hr>`;
            });
        })
        .catch(error => console.error(error));
});
