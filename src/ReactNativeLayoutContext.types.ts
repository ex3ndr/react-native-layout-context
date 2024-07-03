import { StyleProp, ViewStyle } from "react-native";

export type ReactNativeLayoutContextViewProps = {
  name: string;
  children?: React.ReactNode;
  style?: StyleProp<ViewStyle>;
};

export type ReactNativeLayoutEvent = {
  kind: 'keyboardWillShow' | 'keyboardDidShow' | 'keyboardWillHide' | 'keyboardDidHide' | 'keyboardWillChangeFrame' | 'keyboardDidChangeFrame',
  context: string | null,
  startCoordinates: { screenX: number, screenY: number, width: number, height: number },
  endCoordinates: { screenX: number, screenY: number, width: number, height: number },
  duration: number,
  easing: 'easeIn' | 'easeInEaseOut' | 'easeOut' | 'linear' | 'keyboard',
  isEventFromThisApp: boolean,
  keyboardBottom: number,
  safe: {
    top: number,
    bottom: number,
    left: number,
    right: number
  }
}