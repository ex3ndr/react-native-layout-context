import { EventEmitter, Subscription } from 'expo-modules-core';
import ReactNativeLayoutContextModule from './ReactNativeLayoutContextModule';
import { ReactNativeLayoutEvent } from './ReactNativeLayoutContext.types';
const emitter = new EventEmitter(ReactNativeLayoutContextModule);

export function addLayoutEventListener(listener: (event: ReactNativeLayoutEvent) => void): Subscription {
    return emitter.addListener('layoutEvent', listener);
}
