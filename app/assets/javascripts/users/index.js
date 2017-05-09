$(document).ready(function(){
    var $states;

    $("#criterion_volume").chosen();
    function updateCriterionsVolume(){
        var title = this.options[this.selectedIndex].innerHTML;
        var id = this.value;
        $.ajax({
            url: criterion_volume_url,
            data: {
                assignment_id: id, assignment_title: title
            },
            success: function(data) {

                var criterions = $.map(data,function(criterion){
                    return $("<option value=" + criterion[1]+"/>").text(criterion[0])
                });

                $("#criterion_volume").empty().append(criterions);
                $("#criterion_volume").trigger("chosen:updated");
            },
            error: function() {
            }
        });

    }
    function updateAssignmentVolume() {

        var cities = $.map(selectData[this.value], function (city) {
            return $("<option value="+ city[2]+"/>").text(city[1]);
        });
        $("#assignment_title_volume").empty().append(cities);
    }


    var state;
    $courses = $("#course_title_volume").on("change", updateAssignmentVolume);
    for (state in selectData) {
        $("<option />").text(state).appendTo($courses);
    }
    $courses.change();
    $assignments = $("#assignment_title_volume").on("change", updateCriterionsVolume);
//
//                  var criterion_score_frequency = <!--%= @criterion_score_frequency.to_json.html_safe %>;
//
    var myChart4 = echarts.init(document.getElementById('bargraph4'));
//                  // specify chart configuration item and data
    var option4 = {
        title : {
            text: 'Comments Volume',
            subtext: 'by Criterion'
        },
        tooltip : {
            trigger: 'axis'
        },
        legend: {
            show: true,
            data:['意向','预购','成交'],
            top: 'bottom'
        },
        calculable : true,
        xAxis : [
            {
                show: false,
                type : 'category',
                boundaryGap : false,
                data : ['周一','周二','周三','周四','周五','周六','周日']
            }
        ],
        yAxis : [
            {
                type : 'value'
            }
        ],
        series : [
            {
                name:'成交',
                type:'line',
                smooth:true,
                itemStyle: {normal: {areaStyle: {type: 'default'}}},
                data:[10, 12, 21, 54, 260, 830, 710]
            },
            {
                name:'预购',
                type:'line',
                smooth:true,
                itemStyle: {normal: {areaStyle: {type: 'default'}}},
                data:[30, 182, 434, 791, 390, 30, 10]
            },
            {
                name:'意向',
                type:'line',
                smooth:true,
                itemStyle: {normal: {areaStyle: {type: 'default'}}},
                data:[1320, 1132, 601, 234, 120, 90, 20]
            }
        ]
    };
//
//
//                  // use configuration item and data specified to show chart
    myChart4.setOption(option4);
//
    $('#criterionwise_comments_volume button').click(function(event) {
        event.preventDefault();

        $.ajax({
            url: this.parentNode.parentNode.action,
            data: {
                course_title: $("#course_title_volume").val(), assignment_title: $("#assignment_title_volume").val(),
                criterion_ids: $("#criterion_volume").val(), number_split: $("#number_input").val()
            },
            success: function(data) {
                myChart4 = echarts.init(document.getElementById('bargraph4'));
                option4.series = data["series"];
                option4.legend.data = data["legends"];
                option4.xAxis[0].data = data["xaxis"]
                myChart4.setOption(option4);
            },
            error: function() {
            }
        });
    });
});