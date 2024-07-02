import { StyleProp, ViewStyle } from "react-native";

export type ReactNativeLayoutContextViewProps = {
  name: string;
  children?: React.ReactNode;
  style?: StyleProp<ViewStyle>;
};
