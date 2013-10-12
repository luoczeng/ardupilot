/*
 *       Example of AC_AttitudeControl library
 *       DIYDrones.com
 */

#include <AP_Common.h>
#include <AP_Progmem.h>
#include <AP_Math.h>            // ArduPilot Mega Vector/Matrix math Library
#include <AP_Curve.h>           // Curve used to linearlise throttle pwm to thrust
#include <AP_Param.h>
#include <AP_HAL.h>
#include <AP_HAL_AVR.h>

#include <AP_GPS.h>             // ArduPilot GPS library
#include <AP_GPS_Glitch.h>      // GPS glitch protection library
#include <AP_ADC.h>             // ArduPilot Mega Analog to Digital Converter Library
#include <AP_ADC_AnalogSource.h>
#include <AP_Baro.h>            // ArduPilot Mega Barometer Library
#include <Filter.h>
#include <AP_Compass.h>         // ArduPilot Mega Magnetometer Library
#include <AP_Declination.h>
#include <AP_InertialSensor.h>  // ArduPilot Mega Inertial Sensor (accel & gyro) Library
#include <AP_AHRS.h>
#include <AP_Airspeed.h>
#include <AC_PID.h>             // PID library
#include <APM_PI.h>             // PID library
#include <AP_Buffer.h>          // ArduPilot general purpose FIFO buffer
#include <AP_InertialNav.h>     // Inertial Navigation library
#include <GCS_MAVLink.h>
#include <AP_Notify.h>
#include <AP_Vehicle.h>
#include <DataFlash.h>
#include <RC_Channel.h>         // RC Channel Library
#include <AP_Motors.h>
#include <AC_AttitudeControl.h>

const AP_HAL::HAL& hal = AP_HAL_BOARD_DRIVER;

// INS and Baro declaration
#if CONFIG_HAL_BOARD == HAL_BOARD_APM2

AP_InertialSensor_MPU6000 ins;
AP_Baro_MS5611 baro(&AP_Baro_MS5611::spi);

#else

AP_ADC_ADS7844 adc;
AP_InertialSensor_Oilpan ins(&adc);
AP_Baro_BMP085 baro;
#endif

// GPS declaration
GPS *gps;
AP_GPS_Auto auto_gps(&gps);
GPS_Glitch gps_glitch(gps);

AP_Compass_HMC5843 compass;
AP_AHRS_DCM ahrs(&ins, gps);

// Inertial Nav declaration
AP_InertialNav inertial_nav(&ahrs, &ins, &baro, gps, gps_glitch);

// fake PIDs
APM_PI pi_angle_roll, pi_angle_pitch, pi_angle_yaw;
AC_PID pid_rate_roll, pid_rate_pitch, pid_rate_yaw;

// fake RC inputs
RC_Channel rc_roll(CH_1), rc_pitch(CH_2), rc_yaw(CH_4), rc_throttle(CH_3);

// fake motor and outputs
AP_MotorsQuad motors(&rc_roll, &rc_pitch, &rc_throttle, &rc_yaw);
int16_t motor_roll, motor_pitch, motor_yaw, motor_throttle;

// Attitude Control
AC_AttitudeControl ac_control(ahrs, ins, motors, pi_angle_roll, pi_angle_pitch, pi_angle_yaw, pid_rate_roll, pid_rate_pitch, pid_rate_yaw, motor_roll, motor_pitch, motor_yaw, motor_throttle);

void setup()
{
    hal.console->println("AC_AttitudeControl library test");
}

void loop()
{
    // call update function
    hal.console->printf_P(PSTR("hello"));
    hal.scheduler->delay(1);
}

AP_HAL_MAIN();
