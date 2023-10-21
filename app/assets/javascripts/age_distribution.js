google.charts.load('current', {
    'packages': ['corechart']
});
google.charts.setOnLoadCallback(drawChart);

function drawChart() {

var data = google.visualization.arrayToDataTable([
    ['Age Range', 'No. Of Persons', { role: "style" }],
    ['Infant', 1, '#ADD8E6'],
    ['Toddlers', 2, '#89CFF0'],
    ['Preschoolers', 2, '#87CEEB'],
    ['Schoolage', 8, '#6495ED'],
    ['Teenage', 17, '#4169E1'],
    ['Adult', 15, '#000080'],
    ['Senior Citizens', 7, '#191970']
]);

var options = {
    title: 'Age Distribution of IDPs',
    legend: 'none',
    backgroundColor: 'transparent', // Set the entire chart background to be transparent

    titleTextStyle: {
        fontSize: 18, // Specify the font size for the chart title
        fontName: 'Oswald',
    },
    height: '100%',
    width: '100%'
};

var chart = new google.visualization.BarChart(document.getElementById('age_distribution'));

chart.draw(data, options);
}