//
// Decimator
//

#ifndef __LIQUID_DECIM_INTERNAL_H__
#define __LIQUID_DECIM_INTERNAL_H__

#include "filter_common.h"

typedef struct decim_s * decim;

// Create decimator object
//   D    : decimation factor (0 < D < DECIM_FACTOR_MAX)
//   fc   : carrier frequency (-1 < fc < 1)
//   b    : transition bandwidth (0 < b < 1/D < 0.5)
//   slsl : sidelobe suppression level [dB]
decim decim_create(unsigned int _D, float _fc, float _b, float _slsl);

// Destroy decimator object
void decim_destroy(decim _d);

// Execute
void decim_execute(decim _d, float * _x, unsigned int _x_len, float * _y, unsigned int _y_len);

// 
// internal
//

#define DECIM_FACTOR_MAX 2048
struct decim_s {
    decim_type type;
    float * h;
    unsigned int h_len;

    unsigned int D; // decimation factor (D > 0)
    float fc;       // center frequency (-0.5 < fc < 0.5)
    float b;        // filter bandwidth (0 < b < 0.5)
    float t;        // transition bandwidth (0 < t < 0.5), t = 1/D
    float slsl;     // sidelobe suppression level [dB] (slsl < 0)
};

decim decim_create_generic(unsigned int _D, float _fc, float _b, float _slsl);
decim decim_create_halfband(float _fc, float _b, float _slsl);


#endif // __LIQUID_DECIM_INTERNAL_H__
